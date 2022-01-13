defmodule BrewDashWeb.Admin.MenuComponent do
  use BrewDashWeb, :live_component

  alias BrewDash.Tasks

  @impl true
  def handle_event("start_sync", _, socket) do
    Tasks.SyncGrainFatherServer.sync_now(true)
    {:noreply, put_flash(socket, :info, "Sync manually triggered.")}
  end
end
