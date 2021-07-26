defmodule GrainFather.Brew do
  @fields [
    "id",
    "batch_number",
    "original_gravity",
    "final_gravity",
    "created_at",
    "updated_at",
    "fermentation_start_date",
    "recipe_id",
    "notes",
    "name",
    "session_name",
    "status"
  ]
  @default %{
    batch_number: nil,
    brewed_at: nil,
    fermentation_at: nil,
    final_gravity: nil,
    name: nil,
    notes: nil,
    original_gravity: nil,
    source: "grain_father",
    source_id: nil,
    status: nil
  }

  def from_api(%{"recipe" => recipe} = json) do
    json
    |> Map.take(@fields)
    |> Map.update("status", :unknown, &status/1)
    |> Map.put("recipe", GrainFather.Recipe.from_api(recipe))
  end

  def to_brew_dash(brew) do
    %{
      @default
      | batch_number: to_string(brew["batch_number"]),
        brewed_at: brew["created_at"],
        fermentation_at: brew["fermentation_start_date"],
        final_gravity: brew["final_gravity"],
        name: brew["name"],
        notes: brew["notes"],
        original_gravity: brew["original_gravity"],
        source_id: to_string(brew["id"]),
        status: status_to_brew_dash(brew["status"])
    }
  end

  def brew_dash_fields, do: Map.keys(@default)

  def status(5), do: :planning
  def status(10), do: :brewing
  def status(20), do: :fermenting
  def status(30), do: :conditioning
  def status(35), do: :serving
  def status(40), do: :complete

  def status_to_brew_dash(:complete), do: "completed"
  def status_to_brew_dash(as_atom), do: Atom.to_string(as_atom)
end
