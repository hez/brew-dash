defmodule BrewDash.Recipes.Recipe do
  alias BrewDash.Repo
  alias BrewDash.Schema

  require Ecto.Query

  def all, do: Repo.all(Schema.Recipe)

  def upsert!(changeset, fields), do: Repo.insert!(changeset, on_conflict: {:replace, fields})

  def find_by_source_id(source_id),
    do: Schema.Recipe |> Ecto.Query.where(source_id: ^source_id) |> Repo.one()
end
