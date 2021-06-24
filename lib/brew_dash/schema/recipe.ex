defmodule BrewDash.Schema.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  @exportable_attributes [
    :image_url,
    :name
  ]
  @derive {Jason.Encoder, only: @exportable_attributes}

  schema "recipes" do
    field :image_url, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :image_url])
    |> validate_required([:name])
  end
end
