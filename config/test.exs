use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tailwind, TailwindWeb.Endpoint,
  http: [port: 4002],
  server: false

config :tailwind,
  strava_tokens_url: "http://localhost:1336",
  strava_api_url: "http://localhost:1337",
  darksky_api_url: "http://localhost:1338"

# Print only warnings and errors during test
config :logger, level: :warn
