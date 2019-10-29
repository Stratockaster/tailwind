defmodule TailwindWeb.Router do
  use TailwindWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TailwindWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", TailwindWeb do
    pipe_through :api

    get "/segments/:latlon", ApiController, :segments
  end
end
