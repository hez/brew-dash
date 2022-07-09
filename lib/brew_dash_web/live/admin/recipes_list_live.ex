defmodule BrewDashWeb.Admin.RecipesListLive do
  use BrewDashWeb, :live_view

  alias BrewDash.Recipes.Recipe

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch_recipes(socket)}
  end

  def archived_icon(%{recipe: %{is_archived: true}} = assigns) do
    ~H"""
    <div class="pr-3">
      <.icon_with_tool_tip tip="Recipe has been archived" image="delete.svg" />
    </div>
    """
  end

  def archived_icon(assigns), do: ~H""

  defp fetch_recipes(socket), do: assign(socket, recipes: Recipe.all())
end
