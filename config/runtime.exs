use Mix.Config

# Configure your database
config :brew_dash, BrewDash.Repo,
  database: System.get_env("SQLITE_DB_FILE", "./brew_dash.sqlite")
