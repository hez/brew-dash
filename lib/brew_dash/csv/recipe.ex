defmodule BrewDash.CSV.Recipe do
  alias BrewDash.Recipes
  alias BrewDash.Schema.Recipe

  @default %{
    image_url: nil,
    name: nil,
    source: "csv",
    source_id: nil
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
      %{@default | image_url: line["image_url"], name: line["name"], source_id: line["id"]}
    end)
  end

  def write!(attrs) do
    %Recipe{}
    |> Recipe.source_changeset(attrs)
    |> Recipes.Recipe.upsert!(brew_dash_fields())
  end

  defp brew_dash_fields, do: Map.keys(@default)
end
