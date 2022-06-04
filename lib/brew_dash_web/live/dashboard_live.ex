defmodule BrewDashWeb.DashboardLive do
  use BrewDashWeb, :live_view

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}
end
