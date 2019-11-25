defmodule TailwindTest do
  alias Tailwind.Strava.TokenRefresher
  use ExUnit.Case, async: true

  setup_all do
    bypass_strava_tokens = Bypass.open(port: 1336)
    bypass_strava = Bypass.open(port: 1337)
    bypass_darksky = Bypass.open(port: 1338)
    {:ok, bypass_strava: bypass_strava, bypass_darksky: bypass_darksky, bypass_strava_tokens: bypass_strava_tokens}
  end

  test "Calculations are correct", %{bypass_strava: bypass_strava, bypass_darksky: bypass_darksky} do
    read_strava = Task.async(fn -> File.read!("fixtures/strava_response.json") end)
    read_darksky = Task.async(fn -> File.read!("fixtures/darksky_response.json") end)
    read_result = Task.async(fn -> File.read!("fixtures/result.json") end)

    strava_response = Task.await(read_strava)
    Bypass.expect(bypass_strava, fn conn -> Plug.Conn.resp(conn, 200, strava_response) end)
    darksky_response = Task.await(read_darksky)
    Bypass.expect(bypass_darksky, fn conn -> Plug.Conn.resp(conn, 200, darksky_response) end)

    actual = Poison.encode!(Tailwind.get_rated_segments({53.914152, 27.523715}))
    expected = Task.await(read_result)
    assert actual === expected
  end

  test "Token refresher saves new settings", %{bypass_strava_tokens: bypass_strava_tokens} do
    response = "{\"access_token\": \"a9b723\"}"
    Bypass.expect(bypass_strava_tokens, fn conn -> Plug.Conn.resp(conn, 200, response) end)

    assert TokenRefresher.get_settings().access_token === System.fetch_env!("STRAVA_ACCESS_TOKEN")
    :timer.sleep(1000)
    assert TokenRefresher.get_settings().access_token === Poison.decode!(response)["access_token"]
  end
end
