defmodule BrewDash.Tasks.SyncGrainFather do
  alias BrewDash.Brews
  alias BrewDash.Recipes
  alias BrewDash.Schema.Brew
  alias BrewDash.Schema.Recipe

  @grain_father_page_limit 1
  @topics %{
    brew_sessions: "sync_grain_father_brew_sessions_update"
  }

  def subscribe(topic), do: Phoenix.PubSub.subscribe(BrewDash.PubSub, topic_name(topic))
  def topic_name(name), do: @topics[name]

  def sync!(limit \\ @grain_father_page_limit) do
    {:ok, token} = login()
    sync_recipes!(token, limit)
    sync_brew_sessions!(token, limit)
  end

  defp login, do: GrainFather.login()

  def sync_recipes!(token, limit) do
    grain_father_recipes = GrainFather.fetch_all(token, limit, :recipes)

    recipes =
      grain_father_recipes
      |> Enum.map(&GrainFather.Recipe.from_api/1)
      |> Enum.map(&GrainFather.Recipe.to_brew_dash/1)

    Enum.each(recipes, fn recipe ->
      %Recipe{id: recipe[:id]} |> Recipe.changeset(recipe) |> Recipes.Recipe.upsert!()
    end)
  end

  def sync_brew_sessions!(token, limit) do
    grain_father_brews = GrainFather.fetch_all(token, limit, :brew_sessions)

    brews =
      grain_father_brews
      |> Enum.map(&GrainFather.Brew.from_api/1)
      |> Enum.map(&GrainFather.Brew.to_brew_dash/1)

    Enum.each(brews, fn brew ->
      %Brew{id: brew[:id], recipe_id: brew[:recipe_id]}
      |> Brew.changeset(brew)
      |> Brews.Brew.upsert!()
    end)

    broadcast(:brew_sessions, :synced)
  end

  defp broadcast(topic, event),
    do: Phoenix.PubSub.broadcast(BrewDash.PubSub, topic_name(topic), event)
end
