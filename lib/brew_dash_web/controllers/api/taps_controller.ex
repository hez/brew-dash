defmodule BrewDashWeb.API.TapsController do
  use BrewDashWeb, :controller
  require Logger
  alias BrewDash.Brews

  def index(conn, params) do
    statuses = Map.get(params, "statuses", [:serving, :conditioning])

    taps =
      statuses
      |> Brews.Brew.with_statuses()
      |> Enum.sort(&Brews.Display.sort_tap_number/2)
      |> Enum.sort(&Brews.Display.sort_status/2)

    render(conn, :index, taps: taps)
  end
end
