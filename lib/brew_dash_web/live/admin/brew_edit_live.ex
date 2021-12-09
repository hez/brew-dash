defmodule BrewDashWeb.Admin.BrewEditLive do
  use BrewDashWeb, :live_view
  import BrewDash.Brews.Display
  alias BrewDash.Brews.Brew
  alias BrewDash.Schema.Brew, as: BrewSchema

  @impl true
  def mount(%{"id" => _id} = params, _session, socket) do
    {:ok, fetch_brew_session(socket, params)}
  end

  @impl true
  def handle_event("delete", %{"value" => id}, socket) do
    id |> String.to_integer() |> Brew.delete!()

    socket =
      socket
      |> put_flash(:error, "Deleted")
      |> redirect(to: Routes.brews_list_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("validate", %{"brew" => brew}, socket) do
    changeset = BrewSchema.changeset(socket.assigns.brew, brew)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"brew" => brew}, socket) do
    Brew.update!(socket.assigns.brew, brew)
    {:noreply, socket}
  end

  defp fetch_brew_session(socket, "new"), do: socket

  defp fetch_brew_session(socket, params) do
    brew = Brew.get!(params["id"])
    changeset = BrewSchema.changeset(brew, %{})

    socket
    |> assign(brew: brew)
    |> assign(changeset: changeset)
  end
end
