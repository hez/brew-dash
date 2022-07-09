defmodule BrewDash.Schema.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  @exportable_attributes [
    :image_url,
    :is_archived,
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
    field :is_archived, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs),
    do: recipe |> cast(attrs, [:name, :image_url, :is_archived]) |> validate_required([:name])

  def source_changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:source, :source_id])
    |> changeset(attrs)
    |> unique_constraint([:source, :source_id])
  end
end
