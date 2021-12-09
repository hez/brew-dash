defmodule BrewDashWeb.Admin.BrewEditLive do
  use BrewDashWeb, :live_view
  import BrewDash.Brews.Display
  alias BrewDash.Brews.Brew
  alias BrewDash.Schema

  @impl true
  def mount(%{"id" => _id} = params, _session, socket) do
    {:ok, fetch_brew_session(socket, params)}
  end

  @impl true
  def handle_event("delete", %{"value" => id}, socket) do
    Brew.delete!(id)
    BrewDash.Sync.broadcast(:brew_sessions, :brew_sessions_updated)

    socket =
      socket
      |> put_flash(:error, "Deleted")
      |> push_redirect(to: Routes.live_path(socket, BrewDashWeb.Admin.BrewsListLive))

    {:noreply, socket}
  end

  def handle_event("validate", %{"brew" => brew}, socket) do
    changeset = Schema.Brew.changeset(socket.assigns.brew, brew)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"brew" => brew}, socket) do
    Brew.update!(socket.assigns.brew, brew)
    BrewDash.Sync.broadcast(:brew_sessions, :brew_sessions_updated)
    {:noreply, socket}
  end

  defp fetch_brew_session(socket, "new"), do: socket

  defp fetch_brew_session(socket, params) do
    brew = Brew.get!(params["id"])
    changeset = Schema.Brew.changeset(brew, %{})

    socket
    |> assign(brew: brew)
    |> assign(changeset: changeset)
  end
end
