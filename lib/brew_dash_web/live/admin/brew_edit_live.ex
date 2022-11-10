defmodule BrewDashWeb.Admin.BrewEditLive do
  use BrewDashWeb, :live_view
  import BrewDash.Brews.Display
  alias BrewDash.Brews.Brew
  alias BrewDash.Recipes.Recipe
  alias BrewDash.Schema

  @impl true
  def mount(params, _session, socket) do
    {:ok, socket |> fetch_brew_session(params) |> fetch_recipes()}
  end

  @impl true
  def handle_event("delete", %{"value" => id}, socket) do
    Brew.delete!(id)
    BrewDash.Sync.broadcast(:brew_sessions, :brew_sessions_updated)

    socket =
      socket
      |> put_flash(:error, "Deleted")
      |> push_redirect(to: ~p"/admin/brews")

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"brew" => brew}, socket) do
    changeset = Schema.Brew.changeset(socket.assigns.brew, brew)
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", _params, %{assigns: %{live_action: :new}} = socket) do
    brew = Brew.insert!(socket.assigns.changeset)
    BrewDash.Sync.broadcast(:brew_sessions, :brew_sessions_updated)

    socket =
      socket
      |> assign(brew: brew)
      |> put_flash(:info, "New Session Created")
      |> push_redirect(to: ~p"/admin/brews")

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"brew" => brew}, socket) do
    brew = Brew.update!(socket.assigns.brew, brew)
    BrewDash.Sync.broadcast(:brew_sessions, :brew_sessions_updated)

    socket =
      socket
      |> assign(brew: brew)
      |> put_flash(:info, "Session Updated")
      |> push_redirect(to: ~p"/admin/brews")

    {:noreply, socket}
  end

  defp fetch_brew_session(%{assigns: %{live_action: :new}} = socket, _params) do
    brew = %Schema.Brew{source: "manual", recipe: nil}
    changeset = Schema.Brew.changeset(brew, %{})

    socket
    |> assign(brew: brew)
    |> assign(changeset: changeset)
  end

  defp fetch_brew_session(socket, %{"id" => id}) do
    brew = Brew.get!(id)
    changeset = Schema.Brew.changeset(brew, %{})

    socket
    |> assign(brew: brew)
    |> assign(changeset: changeset)
  end

  defp fetch_recipes(socket), do: assign(socket, recipes: Recipe.all())
end
