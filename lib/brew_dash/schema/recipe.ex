defmodule BrewDash.Schema.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  @exportable_attributes [
    :image_url,
    :name,
    :source,
    :source_id
  ]
  @derive {Jason.Encoder, only: @exportable_attributes}

  schema "recipes" do
    field :image_url, :string
    field :name, :string
    field :source, :string
    field :source_id, :string

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs),
    do: recipe |> cast(attrs, [:name, :image_url]) |> validate_required([:name])

  def source_changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:source, :source_id])
    |> changeset(attrs)
    |> unique_constraint([:source, :source_id])
  end
end
