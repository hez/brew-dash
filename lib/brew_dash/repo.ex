defmodule BrewDash.Repo do
  use Ecto.Repo,
    otp_app: :brew_dash,
    adapter: Ecto.Adapters.SQLite3
end
