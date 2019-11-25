defmodule Tailwind.Strava.TokenRefresher do
  @moduledoc false

  use GenServer

  def start_link(initial_settings) do
    GenServer.start_link(__MODULE__, initial_settings, name: :token_refresher)
  end

  @impl true
  def init(initial_settings) do
    schedule_work_immediately()

    {:ok, initial_settings}
  end

  # Отвечает на запрос текущих настроек
  @impl true
  def handle_call(:get, _from, settings) do
    {:reply, settings, settings}
  end

  @impl true
  def handle_info(:work, settings) do
    # Do the desired work here
    {:ok, new_settings} = query_new_tokens(settings)
    |> Map.get(:body)
    |> Poison.decode()

    # Reschedule once more
    schedule_work()

    {:noreply, Map.merge(settings, atomic_map(new_settings))}
  end

  def get_settings do
    GenServer.call(:token_refresher, :get)
  end

  defp schedule_work_immediately do
    Process.send_after(self(), :work, 1000) # Start in 1 second
  end

  defp schedule_work do
    Process.send_after(self(), :work, 1 * 60 * 60 * 1000)
  end

  defp query_new_tokens(settings) do
    %{client_id: client_id, client_secret: client_secret, refresh_token: refresh_token} = settings

    query_result = HTTPoison.post Application.get_env(:tailwind, :strava_tokens_url),
    "{\"client_id\": \"#{client_id}\", \"client_secret\": \"#{client_secret}\", \"grant_type\": \"refresh_token\", \"refresh_token\": \"#{refresh_token}\"}",
    [{"Content-Type", "application/json"}]

    case query_result do
      {:ok, response} -> response
    end
  end

  defp atomic_map(map) do
    for {k, v} <- map, into: %{}, do: {String.to_atom(k), v}
  end
end
