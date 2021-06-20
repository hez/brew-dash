defmodule BrewDashWeb.DashboardLive do
  use BrewDashWeb, :live_view
  require Logger
  alias BrewDash.Brews.Brew
  alias BrewDash.Tasks.SyncGrainFather

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: SyncGrainFather.subscribe(:brew_sessions)

    {:ok, fetch_brew_sessions(socket)}
  end

  @impl true
  def handle_info(:synced, socket) do
    Logger.info("brews sync notification")
    {:noreply, fetch_brew_sessions(socket)}
  end

  defp fetch_brew_sessions(socket) do
    socket
    |> assign(on_board: Brew.conditioning())
    |> assign(on_tap: Brew.serving())
  end
end
