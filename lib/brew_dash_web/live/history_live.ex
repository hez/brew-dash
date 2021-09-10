defmodule BrewDashWeb.HistoryLive do
  use BrewDashWeb, :live_view
  import BrewDash.Brews.Display
  alias BrewDash.Brews.Brew

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch_brew_sessions(socket)}
  end

  defp fetch_brew_sessions(socket), do: assign(socket, brew_sessions: Brew.all())
end
