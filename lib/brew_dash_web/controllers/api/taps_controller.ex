defmodule BrewDashWeb.API.TapsController do
  use BrewDashWeb, :controller
  require Logger
  alias BrewDash.Brews.Brew

  def index(conn, params) do
    statuses = Map.get(params, "statuses", [:serving, :conditioning])
    taps = Brew.with_statuses(statuses)
    render(conn, :index, taps: taps)
  end
end
