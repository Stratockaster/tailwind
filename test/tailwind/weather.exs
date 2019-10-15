defmodule TailwindWeb.WeatherTest do
  use TailwindWeb.ConnCase

  test "get weather", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"

    # assert Tailwind.Weather.get_weather()
  end
end
