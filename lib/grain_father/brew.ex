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
    |> Map.put("abv", abv(json))
    |> Map.put("recipe", GrainFather.Recipe.from_api(recipe))
  end

  def to_brew_dash(brew) do
    brew
    |> Map.take(["original_gravity", "final_gravity", "status", "notes"])
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

  # https://en.wikipedia.org/wiki/Alcohol_by_volume#Practical_estimation_of_alcohol_content
  def abv(%{"original_gravity" => og, "final_gravity" => fg}) when is_float(og) and is_float(fg),
    do: 131 * (og - fg)

  def abv(_), do: :unknown

  def abv1(%{"original_gravity" => og, "final_gravity" => fg}) when is_float(og) and is_float(fg),
    do: 105.0 / 0.79 * (og - fg) / fg

  def abv1(_), do: :unknown
end
