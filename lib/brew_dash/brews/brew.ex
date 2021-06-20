defmodule BrewDash.Brews.Brew do
  require Ecto.Query
  alias BrewDash.Repo
  alias BrewDash.Schema

  def serving, do: all_with_status(:serving)
  def conditioning, do: all_with_status(:conditioning)

  def all_with_status(status),
    do: Schema.Brew |> where_status(status) |> load_recipe() |> Repo.all()

  def where_status(query, status), do: Ecto.Query.where(query, status: ^status)

  def load_recipe(query), do: Ecto.Query.preload(query, [:recipe])

  def upsert!(changeset), do: Repo.insert!(changeset, on_conflict: {:replace_all_except, [:id]})
end
