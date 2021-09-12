defmodule BrewDash.CSV.Brew do
  alias BrewDash.Brews
  alias BrewDash.Recipes
  alias BrewDash.Schema.Brew

  @default %{
    batch_number: nil,
    brewed_at: nil,
    fermentation_at: nil,
    final_gravity: nil,
    name: nil,
    notes: nil,
    original_gravity: nil,
    recipe_id: nil,
    source: "csv",
    source_id: nil,
    status: nil,
    tap_number: nil
  }

  def sync!(csv_path) do
    csv_path
    |> from_file!()
    |> Enum.map(&write!/1)
  end

  def from_file!(path) do
    path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(fn line ->
      %{
        @default
        | batch_number: line["batch_number"],
          brewed_at: line["brewed_at"],
          fermentation_at: line["fermentation_at"],
          name: line["name"],
          notes: line["notes"],
          original_gravity: line["original_gravity"],
          recipe_id: line["recipe_id"],
          source_id: line["id"],
          status: status(line["status"]),
          tap_number: line["tap_number"]
      }
    end)
  end

  def write!(attrs) do
    recipe_id = attrs.recipe_id |> to_string() |> recipe_id_for()

    %Brew{recipe_id: recipe_id}
    |> Brew.source_changeset(attrs)
    |> Brews.Brew.upsert!(brew_dash_fields())
  end

  def status("planning"), do: :planning
  def status("brewing"), do: :brewing
  def status("fermenting"), do: :fermenting
  def status("conditioning"), do: :conditioning
  def status("serving"), do: :serving
  def status("complete"), do: :complete

  defp brew_dash_fields, do: Map.keys(@default)

  defp recipe_id_for(source_recipe_id) do
    case Recipes.Recipe.find_by_source_id(source_recipe_id) do
      nil -> nil
      %{id: id} -> id
    end
  end
end
