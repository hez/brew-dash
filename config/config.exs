# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :brew_dash,
  ecto_repos: [BrewDash.Repo]

config :brew_dash, time_zone: "America/Vancouver"

# Configures the endpoint
config :brew_dash, BrewDashWeb.Endpoint,
  url: [host: nil, port: 4000],
  secret_key_base: "FThhExCo95/BhWoOB0INuQgfOx7Qsu0tXEKY7PqtsxBnFDjoM8rElGR4+nFBdAyQ",
  render_errors: [view: BrewDashWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BrewDash.PubSub,
  live_view: [signing_salt: "OQGYNRDA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:mfa, :request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js js/admin.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.0.12",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ],
  admin: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/admin.css
      --output=../priv/static/assets/admin.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
