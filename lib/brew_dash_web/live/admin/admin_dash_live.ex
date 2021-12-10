defmodule BrewDashWeb.Admin.AdminDashLive do
  use BrewDashWeb, :live_view
  alias BrewDash.Tasks

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: BrewDash.Sync.subscribe(:brew_sessions)

    {:ok, socket}
  end

  @impl true
  def handle_info(:brew_sessions_updated, socket) do
    {:noreply, put_flash(socket, :info, "Sync Finished")}
  end

  @impl true
  def handle_event("start_sync", _, socket) do
    Tasks.SyncGrainFatherServer.sync_now(true)
    {:noreply, put_flash(socket, :info, "Sync manually triggered.")}
  end
end
