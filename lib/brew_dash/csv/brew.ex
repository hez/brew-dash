defmodule BrewDash.CSV.Brew do
  require Logger
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
    resp =
      csv_path
      |> from_file!()
      |> Enum.map(&write!/1)

    BrewDash.Sync.broadcast(:brew_sessions, :brew_sessions_updated)

    resp
  end

  def from_file!(path) do
    path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(fn line ->
      Logger.debug("parsing csv line: #{inspect(line)}")

      %{
        @default
        | batch_number: line["batch_number"],
          brewed_at: parse_datetime(line["brewed_at"]),
          fermentation_at: parse_datetime(line["fermentation_at"]),
          final_gravity: line["final_gravity"],
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
    attrs = %{attrs | recipe_id: recipe_id}

    %Brew{}
    |> Brew.source_changeset(attrs)
    |> Brews.Brew.upsert!(brew_dash_fields())
  end

  def status("planning"), do: :planning
  def status("brewing"), do: :brewing
  def status("fermenting"), do: :fermenting
  def status("conditioning"), do: :conditioning
  def status("serving"), do: :serving
  def status("completed"), do: :completed

  def status(status) do
    Logger.error("Illegal status value of #{inspect(status)}")
    :planning
  end

  defp brew_dash_fields, do: Map.keys(@default)

  defp recipe_id_for(source_recipe_id) do
    case Recipes.Recipe.find_by_source_id(source_recipe_id) do
      nil -> nil
      %{id: id} -> id
    end
  end

  defp parse_datetime(""), do: nil

  defp parse_datetime(date) when is_binary(date) do
    case DateTime.from_iso8601(date) do
      {:ok, datetime, _} ->
        datetime

      err ->
        Logger.error("Error parsing date #{inspect(date)}, with: #{inspect(err)}")
        nil
    end
  end
end
