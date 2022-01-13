defmodule BrewDashWeb.Admin.AdminDashLive do
  use BrewDashWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: BrewDash.Sync.subscribe(:brew_sessions)

    {:ok, socket}
  end

  @impl true
  def handle_info(:brew_sessions_updated, socket) do
    {:noreply, put_flash(socket, :info, "Sync Finished")}
  end
end
