defmodule BrewDash.Brews.Brew do
  require Ecto.Query
  alias BrewDash.Repo
  alias BrewDash.Schema

  def serving, do: all_with_statuses([:serving])
  def conditioning, do: all_with_statuses([:conditioning])

  def all, do: Schema.Brew |> Ecto.Query.order_by(desc: :brewed_at) |> load_recipe() |> Repo.all()

  def get!(id), do: Schema.Brew |> load_recipe() |> Repo.get!(id)

  @spec all_with_statuses(list(atom())) :: [Ecto.Schema.t()]
  def all_with_statuses(statuses),
    do: Schema.Brew |> where_status(statuses) |> load_recipe() |> Repo.all()

  def where_status(query, statuses) when is_list(statuses),
    do: Ecto.Query.where(query, [s], s.status in ^statuses)

  def load_recipe(query), do: Ecto.Query.preload(query, [:recipe])

  @spec upsert!(Ecto.Changeset.t(), list(atom())) :: Ecto.Schema.t()
  def upsert!(changeset, fields), do: Repo.insert!(changeset, on_conflict: {:replace, fields})

  def update!(brew, attrs), do: brew |> Schema.Brew.changeset(attrs) |> Repo.update!()

  def delete!(id) do
    Schema.Brew |> Repo.get!(id) |> Repo.delete()
  end
end
