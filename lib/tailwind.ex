defmodule Tailwind do
  @moduledoc """
  Tailwind keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Tailwind.Point
  alias Tailwind.WeatherFetcher
  alias Tailwind.SegmentFetcher

  def get_rated_segments({lat, lon}) do
    point = %Point{latitude: lat, longitude: lon}

    get_weather_task = Task.async(fn -> WeatherFetcher.get_weather(point) end)
    get_segments_task = Task.async(fn -> SegmentFetcher.get_segments(point) end)

    weather = Task.await(get_weather_task)
    segments = Task.await(get_segments_task)

    %{
      weather: weather,
      rated_segments: Enum.map(segments, fn segment -> calculate_bearing_deltas(segment, Map.get(weather, "windBearingInversed")) end)
    }
  end

  defp calculate_bearing_deltas(segment, wind_bearing_inversed) do
    segment_bearing = Map.get(segment, "bearing")

    bearing_delta = abs(wind_bearing_inversed - segment_bearing)

    if bearing_delta > 180 do
      %{segment: segment, deflection: 360 - segment_bearing + wind_bearing_inversed}
    else
      %{segment: segment, deflection: bearing_delta}
    end
  end
end
