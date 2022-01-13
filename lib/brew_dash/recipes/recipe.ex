defmodule BrewDash.Recipes.Recipe do
  alias BrewDash.Repo
  alias BrewDash.Schema

  require Ecto.Query

  def all, do: Repo.all(Schema.Recipe)

  def get!(id), do: Repo.get!(Schema.Recipe, id)

  def insert!(changeset), do: Repo.insert!(changeset)

  def upsert!(changeset, fields), do: Repo.insert!(changeset, on_conflict: {:replace, fields})

  def update!(recipe, attrs), do: recipe |> Schema.Recipe.changeset(attrs) |> Repo.update!()

  def delete!(id), do: Schema.Recipe |> Repo.get!(id) |> Repo.delete()

  def find_by_source_id(source_id),
    do: Schema.Recipe |> Ecto.Query.where(source_id: ^source_id) |> Repo.one()
end
