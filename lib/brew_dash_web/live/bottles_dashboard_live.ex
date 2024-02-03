defmodule BrewDashWeb.BottlesDashboardLive do
  use BrewDashWeb, :live_view
  require Logger

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, filter: params)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component
      module={BrewDashWeb.BottlesListComponent}
      id="bottles_list"
      filter={@filter}
      render_actions="true"
    />
    """
  end
end
