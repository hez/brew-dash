defmodule BrewDash.Tasks.SyncGrainFather do
  alias BrewDash.Brews
  alias BrewDash.Recipes
  alias BrewDash.Schema.Brew
  alias BrewDash.Schema.Recipe

  @grain_father_page_limit 1

  def sync!(limit \\ @grain_father_page_limit) do
    {:ok, session} = GrainFather.new_session()
    sync_recipes!(session, limit)
    sync_brew_sessions!(session, limit)
  end

  def sync_recipes!(session, limit),
    do: session |> GrainFather.fetch_all_recipes(limit) |> Enum.each(&write_recipe!/1)

  def write_recipe!(recipe) do
    attrs = recipe |> GrainFather.Recipe.from_api() |> GrainFather.Recipe.to_brew_dash()

    %Recipe{}
    |> Recipe.source_changeset(attrs)
    |> Recipes.Recipe.upsert!(GrainFather.Recipe.brew_dash_fields())
  end

  def sync_brew_sessions!(session, limit) do
    session |> GrainFather.fetch_all_brew_sessions(limit) |> Enum.each(&write_brew_session!/1)

    BrewDash.Sync.broadcast(:brew_sessions, :brew_sessions_updated)
  end

  def write_brew_session!(brew) do
    recipe_id = brew["recipe_id"] |> to_string |> recipe_id_for()

    attrs = brew |> GrainFather.Brew.from_api() |> GrainFather.Brew.to_brew_dash()

    %Brew{recipe_id: recipe_id}
    |> Brew.source_changeset(attrs)
    |> Brews.Brew.upsert!(GrainFather.Brew.brew_dash_fields(attrs))
  end

  defp recipe_id_for(source_recipe_id) do
    case Recipes.Recipe.find_by_source_id(source_recipe_id) do
      nil -> nil
      %{id: id} -> id
    end
  end
end
