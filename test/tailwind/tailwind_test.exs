defmodule TailwindTest do
  use ExUnit.Case, async: true

  setup do
    bypass_strava = Bypass.open(port: 1337)
    bypass_darksky = Bypass.open(port: 1338)
    {:ok, bypass_strava: bypass_strava, bypass_darksky: bypass_darksky}
  end

  test "Responds with 200", %{bypass_strava: bypass_strava, bypass_darksky: bypass_darksky} do
    {:ok, strava_response} = File.read("fixtures/strava_response.json")
    {:ok, darksky_response} = File.read("fixtures/darksky_response.json")
    {:ok, expected} = File.read("fixtures/result.json")

    Bypass.expect(bypass_strava, fn conn -> Plug.Conn.resp(conn, 200, strava_response) end)
    Bypass.expect(bypass_darksky, fn conn -> Plug.Conn.resp(conn, 200, darksky_response) end)

    # IO.inspect(Tailwind.get_rated_segments({53.914152, 27.523715}))

    actual = Poison.encode!(Tailwind.get_rated_segments({53.914152, 27.523715}))

    assert actual === expected
  end
end
