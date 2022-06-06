defmodule BrewDash.CSV.Bottle do
  require Logger
  alias BrewDash.Bottles
  alias BrewDash.Schema.Bottle

  @default %{
    company: nil,
    name: nil,
    style: nil,
    vintage: nil,
    purchased_at: nil,
    drunk_at: nil,
    size: nil,
    quantity: nil,
    location: nil,
    notes: nil
  }

  def import!(csv_path) do
    csv_path
    |> from_file!()
    |> Enum.map(&write!/1)
  end

  def from_file!(path) do
    path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(fn line ->
      Logger.debug("parsing csv line: #{inspect(line)}")

      %{
        @default
        | company: line["company"],
          name: line["name"],
          style: line["style"],
          vintage: line["vintage"],
          purchased_at: parse_datetime(line["purchased_at"]),
          drunk_at: parse_datetime(line["drunk_at"]),
          size: line["size"],
          quantity: line["quantity"],
          location: line["location"],
          notes: line["notes"]
      }
    end)
  end

  def write!(attrs) do
    %Bottle{}
    |> Bottle.changeset(attrs)
    |> Bottles.Bottle.upsert!(Map.keys(@default))
  end

  defp parse_datetime(nil), do: nil

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
