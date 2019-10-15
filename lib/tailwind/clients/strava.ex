defmodule Tailwind.Strava do
	use HTTPoison.Base

	@expected_fields ~w(segments)

  def process_request_url(url) do
    "https://www.strava.com/api/v3/segments/explore" <> url
  end

  def process_request_headers(_headers) do
    %{access_token: access_token} = Tailwind.Strava.TokenRefresher.get_settings
    ["Authorization": "Bearer #{access_token}"]
  end

  def process_request_options(_options) do
    [recv_timeout: 10000]
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
  end

  # def process_response_status_code(401) do
  #   IO.puts "need to refresh"
  # end
end

# http POST https://www.strava.com/oauth/token 
# grant_type=refresh_token
# client_id=21181
# client_secret=76cc4c1494c636d2ed3cf5e83a3705b77b86ccbd
# refresh_token=b90607de280f2a8b485eabd7acab79302c087aeb