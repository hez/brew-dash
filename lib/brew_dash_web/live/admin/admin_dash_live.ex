defmodule BrewDashWeb.Admin.AdminDashLive do
  use BrewDashWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("start_sync", _, socket) do
    BrewDash.Tasks.SyncGrainFatherServer.sync_now(true)
    {:noreply, socket}
  end
end
