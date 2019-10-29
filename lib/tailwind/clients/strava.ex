defmodule Tailwind.Strava do
  @moduledoc false

  alias Tailwind.Strava.TokenRefresher

  use HTTPoison.Base

  @expected_fields ~w(segments)

  def process_request_url(url) do
    "https://www.strava.com/api/v3/segments/explore" <> url
  end

  def process_request_headers(_headers) do
    %{access_token: access_token} = TokenRefresher.get_settings()
    ["Authorization": "Bearer #{access_token}"]
  end

  def process_request_options(_options) do
    [recv_timeout: 10_000]
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
  end
end
