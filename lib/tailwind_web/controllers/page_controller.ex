defmodule TailwindWeb.PageController do
  use TailwindWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
