defmodule BrewDash.Bottles.Bottle do
  require Ecto.Query
  alias BrewDash.Repo
  alias BrewDash.Schema

  def cellared(filter \\ [], sort \\ [:company, :name, :vintage]) do
    Schema.Bottle
    |> Ecto.Query.where([b], is_nil(b.drunk_at))
    |> Ecto.Query.where(^filter)
    |> Ecto.Query.order_by(^sort)
    |> Repo.all()
  end

  def all(filter \\ [], sort \\ [:company, :name, :vintage]),
    do: Schema.Bottle |> Ecto.Query.where(^filter) |> Ecto.Query.order_by(^sort) |> Repo.all()

  def get!(id), do: Repo.get!(Schema.Bottle, id)

  def insert!(changeset), do: Repo.insert!(changeset)

  @spec upsert!(Ecto.Changeset.t(), list(atom())) :: Ecto.Schema.t()
  def upsert!(changeset, fields), do: Repo.insert!(changeset, on_conflict: {:replace, fields})

  def update!(bottle, attrs), do: bottle |> Schema.Bottle.changeset(attrs) |> Repo.update!()
end
