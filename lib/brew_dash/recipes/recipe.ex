defmodule BrewDash.Recipes.Recipe do
  alias BrewDash.Repo
  alias BrewDash.Schema

  require Ecto.Query

  def upsert!(changeset), do: Repo.insert!(changeset, on_conflict: {:replace_all_except, [:id]})

  def find_by_source_id(source_id),
    do: Schema.Recipe |> Ecto.Query.where(source_id: ^source_id) |> Repo.one()
end
