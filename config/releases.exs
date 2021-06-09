import Config

config :brew_dash, BrewDash.Repo,
  database: System.get_env("SQLITE_DB_FILE", "/data/brew_dash.sqlite")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :brew_dash, BrewDashWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :brew_dash, BrewDashWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
