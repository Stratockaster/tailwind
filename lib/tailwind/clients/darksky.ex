defmodule Tailwind.Darksky do
  @moduledoc false

  use HTTPoison.Base

  @expected_fields ~w(currently)

  def process_request_url(url) do
    "https://api.darksky.net/forecast/e3a2a08e9c4ab09f4718c2fbe8aeb48c" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
  end
end
