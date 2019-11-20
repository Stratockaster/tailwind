defmodule Tailwind.Darksky do
  @moduledoc false

  use HTTPoison.Base

  @expected_fields ~w(currently)

  def process_request_url(url) do
    Application.get_env(:tailwind, :darksky_api_url) <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Map.get("currently")
  end
end
