defmodule GrainFather.Brew do
  @fields [
    "id",
    "original_gravity",
    "final_gravity",
    "created_at",
    "updated_at",
    "fermentation_start_date",
    "recipe_id",
    "notes",
    "session_name",
    "status"
  ]

  def from_api(%{"recipe" => recipe} = json) do
    json
    |> Map.take(@fields)
    |> Map.update("status", :unknown, &status/1)
    |> Map.put("recipe", GrainFather.Recipe.from_api(recipe))
  end

  def to_brew_dash(brew) do
    brew
    |> Map.take(["id", "recipe_id", "original_gravity", "final_gravity", "status", "notes"])
    |> Map.put("status", status_to_brew_dash(brew["status"]))
    |> Map.put("name", brew["session_name"])
    |> Map.put("brewed_at", brew["created_at"])
    |> Map.put("fermentation_at", brew["fermentation_start_date"])
  end

  def status(5), do: :unknown
  def status(10), do: :unknown
  def status(20), do: :fermenting
  def status(30), do: :conditioning
  def status(35), do: :serving
  def status(40), do: :complete

  def status_to_brew_dash(:complete), do: "completed"
  def status_to_brew_dash(as_atom), do: Atom.to_string(as_atom)
end
