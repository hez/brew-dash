defmodule GrainFather.Brew do
  @source_string "grain_father"
  @tap_number_regex ~r/\[tap_number: (?<tap_number>.*)\]/U
  @tags_regex [{"gf", ~r/\[gf\]/U}]

  @api_fields [
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
    |> Map.take(@api_fields)
    |> Map.update("status", :unknown, &status/1)
    |> Map.put("recipe", GrainFather.Recipe.from_api(recipe))
  end

  def to_brew_dash(brew) do
    %{
      batch_number: to_string(brew["batch_number"]),
      brewed_at: brew["created_at"],
      fermentation_at: brew["fermentation_start_date"],
      final_gravity: brew["final_gravity"],
      name: brew["name"],
      notes: brew["notes"],
      original_gravity: brew["original_gravity"],
      source: @source_string,
      source_id: to_string(brew["id"]),
      status: status_to_brew_dash(brew["status"]),
      tap_number: parse_tap_number(brew["notes"]),
      tags: parse_tags(brew["notes"])
    }
    |> Enum.reject(fn
      {_key, nil} -> true
      _ -> false
    end)
    |> Enum.into(%{})
  end

  def brew_dash_fields(brew), do: Map.keys(brew)

  def status(5), do: :planning
  def status(10), do: :brewing
  def status(20), do: :fermenting
  def status(30), do: :conditioning
  def status(35), do: :serving
  def status(40), do: :complete

  def status_to_brew_dash(:complete), do: "completed"
  def status_to_brew_dash(as_atom), do: Atom.to_string(as_atom)

  @spec parse_tap_number(String.t() | nil) :: String.t() | nil
  def parse_tap_number(nil), do: nil

  def parse_tap_number(notes) do
    case Regex.named_captures(@tap_number_regex, notes) do
      %{"tap_number" => num} -> num
      _ -> nil
    end
  end

  def parse_tags(notes) when is_binary(notes) do
    @tags_regex
    |> Enum.map(fn {name, regex} ->
      if Regex.match?(regex, notes) do
        name
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def parse_tags(_), do: []
end
