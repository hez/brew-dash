defmodule BrewDashWeb.Admin.BottleEditLive do
  use BrewDashWeb, :live_view
  alias BrewDash.Bottles.Bottle
  alias BrewDash.Schema

  @impl true
  def mount(params, _session, socket) do
    {:ok, fetch_bottle(socket, params)}
  end

  @impl true
  def handle_event("validate", %{"bottle" => bottle}, socket) do
    changeset = Schema.Bottle.changeset(socket.assigns.bottle, bottle)
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", _params, %{assigns: %{live_action: :new}} = socket) do
    bottle = Bottle.insert!(socket.assigns.changeset)

    socket =
      socket
      |> assign(bottle: bottle)
      |> put_flash(:info, "New Bottle Created")
      |> push_redirect(to: Routes.live_path(socket, BrewDashWeb.Admin.BottlesListLive))

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"bottle" => bottle}, socket) do
    bottle = Bottle.update!(socket.assigns.bottle, bottle)

    socket =
      socket
      |> assign(bottle: bottle)
      |> put_flash(:info, "Bottle Updated")
      |> push_redirect(to: Routes.live_path(socket, BrewDashWeb.Admin.BottlesListLive))

    {:noreply, socket}
  end

  defp fetch_bottle(%{assigns: %{live_action: :new}} = socket, _params) do
    bottle = %Schema.Bottle{}
    changeset = Schema.Bottle.changeset(bottle, %{})

    socket
    |> assign(bottle: bottle)
    |> assign(changeset: changeset)
  end

  defp fetch_bottle(socket, %{"id" => id}) do
    bottle = Bottle.get!(id)
    changeset = Schema.Bottle.changeset(bottle, %{})

    socket
    |> assign(bottle: bottle)
    |> assign(changeset: changeset)
  end
end
