defmodule BrewDashWeb.DashboardLive do
  use BrewDashWeb, :live_view
  require Logger
  alias BrewDash.Brews.Brew

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(on_board: Brew.conditioning())
      |> assign(on_tap: Brew.serving())

    {:ok, socket}
  end
end
