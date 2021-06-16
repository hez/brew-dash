# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :brew_dash,
  ecto_repos: [BrewDash.Repo]

# Configures the endpoint
config :brew_dash, BrewDashWeb.Endpoint,
  url: [host: "localhost"],
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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
