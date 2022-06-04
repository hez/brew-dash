defmodule BrewDash.Bottles.Bottle do
  require Ecto.Query
  alias BrewDash.Repo
  alias BrewDash.Schema

  def all, do: Schema.Bottle |> Ecto.Query.order_by(desc: :purchased_at) |> Repo.all()
  def get!(id), do: Repo.get!(Schema.Bottle, id)

  @spec upsert!(Ecto.Changeset.t(), list(atom())) :: Ecto.Schema.t()
  def upsert!(changeset, fields), do: Repo.insert!(changeset, on_conflict: {:replace, fields})
end
