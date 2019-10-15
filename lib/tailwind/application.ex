defmodule Tailwind.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      TailwindWeb.Endpoint,
      # Starts a worker by calling: Tailwind.Worker.start_link(arg)
      # {Tailwind.Worker, arg},
      {Tailwind.Strava.TokenRefresher, 
        %{
          client_id: System.fetch_env!("STRAVA_CLIENT_ID"),
          client_secret: System.fetch_env!("STRAVA_CLIENT_SECRET"),
          access_token: System.fetch_env!("STRAVA_ACCESS_TOKEN"),
          refresh_token: System.fetch_env!("STRAVA_REFRESH_TOKEN")
        }
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tailwind.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TailwindWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
