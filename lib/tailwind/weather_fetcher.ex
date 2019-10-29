defmodule Tailwind.WeatherFetcher do
  @moduledoc false

  alias Tailwind.Point

  def get_weather(%Point{latitude: lat, longitude: lon}) do
    Tailwind.Darksky.start
    Tailwind.Darksky.get!("/#{lat},#{lon}?exclude=minutely,hourly,daily,alerts").body
    |> Map.get("currently")
    |> add_inversed_bearing()
  end

  defp add_inversed_bearing(weather) do
    Map.put(weather, "windBearingInversed", inverse_bearing(weather["windBearing"]))
  end

  @spec inverse_bearing(integer) :: integer
  defp inverse_bearing(wind_bearing) when wind_bearing < 180, do: wind_bearing + 180
  defp inverse_bearing(wind_bearing), do: abs(180 - (360 - wind_bearing))
end
