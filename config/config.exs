# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :tailwind, TailwindWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eFu8uDfuN+/nqvCME+LmpNhyh1RnqmJ8YI2xf3p4o3Y3EH4YF/lJXxnABo+sX+x/",
  render_errors: [view: TailwindWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tailwind.PubSub, adapter: Phoenix.PubSub.PG2]

config :tailwind,
  strava_api_url: "https://www.strava.com/api/v3/segments/explore",
  darksky_api_url: "https://api.darksky.net/forecast/e3a2a08e9c4ab09f4718c2fbe8aeb48c"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
