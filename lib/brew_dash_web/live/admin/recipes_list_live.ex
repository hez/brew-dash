defmodule BrewDashWeb.Admin.RecipesListLive do
  use BrewDashWeb, :live_view

  alias BrewDash.Recipes.Recipe

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch_recipes(socket)}
  end

  defp fetch_recipes(socket), do: assign(socket, recipes: Recipe.all())
end
