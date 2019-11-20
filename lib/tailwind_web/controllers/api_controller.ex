defmodule TailwindWeb.ApiController do
  use TailwindWeb, :controller

  def segments(conn, %{"latlon" => latlon}) do
  	# TODO validate incoming latlon
    [lat, lon] = String.split(latlon, ",", parts: 2)

    segments = Tailwind.get_rated_segments({String.to_float(lat), String.to_float(lon)})

    json(conn, segments)
  end
end
