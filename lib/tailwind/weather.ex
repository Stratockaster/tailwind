defmodule Tailwind.Weather do
	def get_weather({lat, lon}) do
		Tailwind.Darksky.start
		Tailwind.Darksky.get!("/#{lat},#{lon}?exclude=minutely,hourly,daily,alerts").body
		|> Map.get("currently")
		|> inverse_bearing
	end

	defp inverse_bearing(weather) do
		wind_bearing = Map.get(weather, "windBearing")
		wind_bearing_inversed = abs(180 - (360 - wind_bearing))
		Map.put(weather, "windBearingInversed", wind_bearing_inversed)
	end
end
