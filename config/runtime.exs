import Config

if config_env() == :prod do
  config :brew_dash, BrewDash.Repo,
    database: System.get_env("SQLITE_DB_FILE", "/data/brew_dash.sqlite")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :brew_dash, BrewDashWeb.Endpoint, server: true

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :brew_dash, BrewDashWeb.Endpoint,
    url: [host: host, port: 443],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # GrainFather config
  config :brew_dash, GrainFather,
    username: System.get_env("GRAINFATHER_USERNAME"),
    password: System.get_env("GRAINFATHER_PASSWORD")
end
