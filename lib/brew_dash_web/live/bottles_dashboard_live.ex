defmodule BrewDashWeb.BottlesDashboardLive do
  use BrewDashWeb, :live_view
  require Logger

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, filter: params)}
  end
end
