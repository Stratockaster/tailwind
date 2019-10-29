defmodule Tailwind.SegmentFetcher do
  @moduledoc false

  alias Tailwind.Area
  alias Tailwind.AreaData
  alias Tailwind.Point

  @spec get_segments(Point.t()) :: map()
  def get_segments(point) do
    area = make_area_from_point(point)

    Tailwind.Strava.start
    case Tailwind.Strava.get("?bounds=#{AreaData.to_string(area)}&activity_type=cycling&min_cat=0&max_cat=5") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Map.get("segments")
        |> Enum.map(&put_bearing/1)
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        raise "Auth error. Check strava access token at https://www.strava.com/settings/api"
      {:error, %HTTPoison.Error{reason: reason}} ->
        raise reason        
    end
  end

  @spec make_area_from_point(Point.t()) :: map()
  defp make_area_from_point(%Point{latitude: lat, longitude: lon}) do
    southwest_point = %Point{latitude: lat - 0.25, longitude: lon - 0.65}
    northeast_point = %Point{latitude: lat + 0.25, longitude: lon + 0.65}

    %Area{southwest_point: southwest_point, northeast_point: northeast_point}
  end

  defp put_bearing(segment) do
    Map.put(segment, "bearing", calculate_bearing(segment))
  end

  defp calculate_bearing(segment) do
    Geocalc.bearing(segment["start_latlng"], segment["end_latlng"]) * 180 / :math.pi()
    |> normalize_bearing
  end

  @spec normalize_bearing(integer) :: integer
  defp normalize_bearing(bearing) when bearing < 0, do: bearing + 360
  defp normalize_bearing(bearing), do: bearing
end

# iex(1)> point = %Tailwind.Point{latitude: 53.914152, longitude: 27.523715}
# %Tailwind.Point{latitude: 53.914152, longitude: 27.523715}
# iex(3)> Tailwind.SegmentFetcher.get_segments(point)

# {53.914152, 27.523715}
