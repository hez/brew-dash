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

  def from_api(%{"recipe" => recipe} = json) do
    json
    |> Map.take(@fields)
    |> Map.update("status", :unknown, &status/1)
    |> Map.put("recipe", GrainFather.Recipe.from_api(recipe))
  end

  def to_brew_dash(brew) do
    brew
    |> Map.take(["id", "recipe_id", "original_gravity", "final_gravity", "status", "notes"])
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    |> Map.put(:batch_number, to_string(brew["batch_number"]))
    |> Map.put(:name, name_to_brew_dash(brew))
    |> Map.put(:status, status_to_brew_dash(brew["status"]))
    |> Map.put(:brewed_at, brew["created_at"])
    |> Map.put(:fermentation_at, brew["fermentation_start_date"])
  end

  def status(5), do: :planning
  def status(10), do: :brewing
  def status(20), do: :fermenting
  def status(30), do: :conditioning
  def status(35), do: :serving
  def status(40), do: :complete

  def status_to_brew_dash(:complete), do: "completed"
  def status_to_brew_dash(as_atom), do: Atom.to_string(as_atom)

  def name_to_brew_dash(%{"name" => name}) when is_binary(name), do: name
  def name_to_brew_dash(%{"session_name" => name}), do: name
end
