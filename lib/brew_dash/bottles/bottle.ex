defmodule BrewDash.Bottles.Bottle do
  require Ecto.Query
  alias BrewDash.Repo
  alias BrewDash.Schema

  @attrs_deleted_when_cloned [:id, :__meta__, :inserted_at, :updated_at, :location]

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

  @spec upsert!(Ecto.Changeset.t(), list(atom())) :: Ecto.Schema.t()
  def upsert!(changeset, fields), do: Repo.insert!(changeset, on_conflict: {:replace, fields})

  def insert!(attrs), do: Repo.insert!(attrs)

  def insert(attrs), do: Repo.insert(attrs)

  def update!(bottle, attrs), do: bottle |> Schema.Bottle.changeset(attrs) |> Repo.update!()

  def update(bottle, attrs), do: bottle |> Schema.Bottle.changeset(attrs) |> Repo.update()

  def remove(bottle, quantity \\ 1)

  def remove(%_{quantity: existing}, quantity) when quantity > existing,
    do: {:error, "Error asked to remove more then is avaible"}

  def remove(%_{quantity: quantity} = bottle, quantity),
    do: update(bottle, %{drunk_at: DateTime.utc_now(), location: nil})

  def remove(%_{quantity: old_quantity} = bottle, quantity) do
    update(bottle, %{quantity: old_quantity - quantity})

    attrs = clone_to_map(bottle, %{quantity: quantity, drunk_at: DateTime.utc_now()})

    %Schema.Bottle{} |> Schema.Bottle.changeset(attrs) |> insert()
  end

  def clone_to_map(bottle, new_attrs) do
    bottle |> Map.from_struct() |> Map.drop(@attrs_deleted_when_cloned) |> Map.merge(new_attrs)
  end
end
