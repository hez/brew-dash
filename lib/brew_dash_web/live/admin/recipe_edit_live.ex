defmodule BrewDashWeb.Admin.RecipeEditLive do
  use BrewDashWeb, :live_view

  alias BrewDash.Recipes.Recipe
  alias BrewDash.Schema

  @impl true
  def mount(params, _session, socket) do
    {:ok, fetch_recipe(socket, params)}
  end

  @impl true
  def handle_event("delete", %{"value" => id}, socket) do
    Recipe.delete!(id)
    # TODO implement handling
    # BrewDash.Sync.broadcast(:brew_sessions, :recipe_updated)

    socket =
      socket
      |> put_flash(:error, "Deleted")
      |> push_redirect(to: Routes.live_path(socket, BrewDashWeb.Admin.RecipesListLive))

    {:noreply, socket}
  end

  def handle_event("validate", %{"recipe" => recipe}, socket) do
    changeset = Schema.Recipe.changeset(socket.assigns.recipe, recipe)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", _params, %{assigns: %{live_action: :new}} = socket) do
    recipe = Recipe.insert!(socket.assigns.changeset)
    # TODO implement handling
    # BrewDash.Sync.broadcast(:brew_sessions, :recipe_updated)

    socket =
      socket
      |> assign(recipe: recipe)
      |> put_flash(:info, "New Recipe Created")
      |> push_redirect(to: Routes.live_path(socket, BrewDashWeb.Admin.RecipeListLive))

    {:noreply, socket}
  end

  def handle_event("save", %{"recipe" => recipe}, socket) do
    recipe = Recipe.update!(socket.assigns.recipe, recipe)
    # TODO implement handling
    # BrewDash.Sync.broadcast(:brew_sessions, :recipe_updated)

    socket =
      socket
      |> assign(recipe: recipe)
      |> put_flash(:info, "Recipe Updated")
      |> push_redirect(to: Routes.live_path(socket, BrewDashWeb.Admin.RecipesListLive))

    {:noreply, socket}
  end

  defp fetch_recipe(%{assigns: %{live_action: :new}} = socket, _params) do
    recipe = %Schema.Recipe{source: "manual"}
    changeset = Schema.Recipe.changeset(recipe, %{})

    socket
    |> assign(recipe: recipe)
    |> assign(changeset: changeset)
  end

  defp fetch_recipe(socket, %{"id" => id}) do
    recipe = Recipe.get!(id)
    changeset = Schema.Recipe.changeset(recipe, %{})

    socket
    |> assign(recipe: recipe)
    |> assign(changeset: changeset)
  end
end
