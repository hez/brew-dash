defmodule BrewDash.Brews.Brew do
  require Ecto.Query
  alias BrewDash.Repo
  alias BrewDash.Schema

  def serving, do: with_statuses([:serving])
  def conditioning, do: with_statuses([:conditioning])
  def brewing(count \\ 1), do: with_statuses([:brewing], count)
  def fermenting(count \\ 1), do: with_statuses([:fermenting], count)

  def all, do: Schema.Brew |> Ecto.Query.order_by(desc: :brewed_at) |> load_recipe() |> Repo.all()

  def get!(id), do: Schema.Brew |> load_recipe() |> Repo.get!(id)

  @spec with_statuses(list(atom()), integer() | nil) :: [Ecto.Schema.t()]
  def with_statuses(statuses, count \\ nil)

  def with_statuses(statuses, nil) do
    Schema.Brew
    |> where_status(statuses)
    |> Ecto.Query.order_by(desc: :brewed_at)
    |> load_recipe()
    |> Repo.all()
  end

  def with_statuses(statuses, count) do
    Schema.Brew
    |> where_status(statuses)
    |> Ecto.Query.limit(^count)
    |> Ecto.Query.order_by(desc: :brewed_at)
    |> load_recipe()
    |> Repo.all()
  end

  def where_status(query, statuses) when is_list(statuses),
    do: Ecto.Query.where(query, [s], s.status in ^statuses)

  def load_recipe(query), do: Ecto.Query.preload(query, [:recipe])

  def insert!(changeset), do: Repo.insert!(changeset)

  @spec upsert!(Ecto.Changeset.t(), list(atom())) :: Ecto.Schema.t()
  def upsert!(changeset, fields), do: Repo.insert!(changeset, on_conflict: {:replace, fields})

  def update!(brew, attrs), do: brew |> Schema.Brew.changeset(attrs) |> Repo.update!()

  def delete!(id), do: Schema.Brew |> Repo.get!(id) |> Repo.delete()
end
