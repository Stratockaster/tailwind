defmodule Tailwind do
  @moduledoc """
  Tailwind keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Tailwind.Point
  alias Tailwind.Area
  alias Tailwind.AreaData

  @spec get_rated_segments({}) :: map()
  def get_rated_segments({lat, lon}) do
    point = %Point{latitude: lat, longitude: lon}

    get_weather_task = Task.async(fn -> get_weather(point) end)
    get_segments_task = Task.async(fn -> get_segments(point) end)

    weather = Task.await(get_weather_task)
    segments = Task.await(get_segments_task, 10_000)

    calculate_result(segments, weather)
  end

  def calculate_result(segments, weather) do
    wind_bearing_inversed = inverse_bearing(weather["windBearing"])

    normalized_weather = weather
      |> Map.put("windBearingInversed", wind_bearing_inversed)

    normalized_segments = segments
      |> Stream.map(fn segment -> Map.put(segment, "bearing", calculate_segment_bearing(segment)) end)
      |> Stream.map(fn segment -> %{segment: segment, deflection: calculate_bearing_delta(segment["bearing"], wind_bearing_inversed)} end)
      |> Enum.map(&(&1))

    %{
      weather: normalized_weather,
      rated_segments: normalized_segments
    }
  end

  @spec get_weather(%Point{}) :: map()
  def get_weather(%Point{latitude: lat, longitude: lon}) do
    Tailwind.Darksky.start
    Tailwind.Darksky.get!("/#{lat},#{lon}?exclude=minutely,hourly,daily,alerts").body
  end

  @spec get_segments(Point.t()) :: map()
  def get_segments(point) do
    area = make_area_from_point(point)

    Tailwind.Strava.start
    case Tailwind.Strava.get("?bounds=#{AreaData.to_string(area)}&activity_type=cycling&min_cat=0&max_cat=5") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        raise "Auth error. Check strava access token at https://www.strava.com/settings/api"
      {:error, %HTTPoison.Error{reason: reason}} ->
        raise reason
    end
  end

  defp calculate_bearing_delta(bearing_1, bearing_2) do
    bearing_delta = abs(bearing_1 - bearing_2)

    if bearing_delta > 180 do
      360 - bearing_1 + bearing_2
    else
      bearing_delta
    end
  end

  @spec inverse_bearing(integer) :: integer
  defp inverse_bearing(bearing) when bearing < 180, do: bearing + 180
  defp inverse_bearing(bearing), do: abs(180 - (360 - bearing))

  @spec make_area_from_point(Point.t()) :: map()
  defp make_area_from_point(%Point{latitude: lat, longitude: lon}) do
    southwest_point = %Point{latitude: lat - 0.25, longitude: lon - 0.65}
    northeast_point = %Point{latitude: lat + 0.25, longitude: lon + 0.65}

    %Area{southwest_point: southwest_point, northeast_point: northeast_point}
  end

  defp calculate_segment_bearing(segment) do
    calculate_bearing(segment["start_latlng"], segment["end_latlng"])
  end

  defp calculate_bearing(point_1, point_2) do
    Geocalc.bearing(point_1, point_2) * 180 / :math.pi()
    |> normalize_bearing
  end

  @spec normalize_bearing(integer) :: integer
  defp normalize_bearing(bearing) when bearing < 0, do: bearing + 360
  defp normalize_bearing(bearing), do: bearing
end
