defmodule Tailwind.Segment do
	def get_segments({lat, lon}) do
		southwest_lat = lat - 0.25
		southwest_lon = lon - 0.65
		northeast_lat = lat + 0.25
		northeast_lon = lon + 0.65

		Tailwind.Strava.start
		Tailwind.Strava.get!("?bounds=#{southwest_lat},#{southwest_lon},#{northeast_lat},#{northeast_lon}&activity_type=cycling&min_cat=0&max_cat=5").body
		|> Map.get("segments")
		|> Enum.map(&calculate_bearing/1)
		# case Tailwind.Strava.get("?bounds=#{southwest_lat},#{southwest_lon},#{northeast_lat},#{northeast_lon}&activity_type=cycling&min_cat=0&max_cat=5") do
		#   {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
		#   	body
		# 		|> Map.get("segments")
		# 		|> Enum.map(&calculate_bearing/1)
		#   {:ok, %HTTPoison.Response{status_code: 401}} ->
		#     IO.puts 401
		#   {:error, %HTTPoison.Error{reason: reason}} ->
		#     IO.inspect reason
		# end
	end

	defp calculate_bearing(segment) do
		bearing = Geocalc.bearing(Map.get(segment, "start_latlng"), Map.get(segment, "end_latlng")) * 180 / :math.pi()
		|> normalize_bearing

		Map.put(segment, "bearing", bearing)
	end

	defp normalize_bearing(bearing) when bearing < 0, do: bearing + 360
	defp normalize_bearing(bearing) do
		bearing
	end
end

# {:ok, 
# 	%HTTPoison.Response{
# 		body: %{}, 
# 		headers: [
# 			{"Date", "Fri, 11 Oct 2019 11:49:26 GMT"}, {"Content-Type", "application/json; charset=utf-8"}, {"Transfer-Encoding", "chunked"}, {"Connection", "keep-alive"}, {"Cache-Control", "no-cache"}, {"Via", "1.1 linkerd"}, {"X-Download-Options", "noopen"}, {"Status", "401 Unauthorized"}, {"X-Request-Id", "60e2af8b-c340-45a7-b4e5-d06663ec17d2"}, {"Referrer-Policy", "strict-origin-when-cross-origin"}, {"X-FRAME-OPTIONS", "DENY"}, {"X-Permitted-Cross-Domain-Policies", "none"}, {"X-Content-Type-Options", "nosniff"}, {"Vary", "Origin"}, {"X-XSS-Protection", "1; mode=block"}
# 		], 
# 		request: %HTTPoison.Request{
# 			body: "", 
# 			headers: [Authorization: "Bearer 0e69582f953f41cc844da6a6b7af937f438191da"], 
# 			method: :get, 
# 			options: [recv_timeout: 10000], 
# 			params: %{}, 
# 			url: "https://www.strava.com/api/v3/segments/explore?bounds=53.650167,26.903091,54.150167,28.203090999999997&activity_type=cycling&min_cat=0&max_cat=5"
# 		}, 
# 		request_url: "https://www.strava.com/api/v3/segments/explore?bounds=53.650167,26.903091,54.150167,28.203090999999997&activity_type=cycling&min_cat=0&max_cat=5", 
# 		status_code: :ok
# 	}
# }