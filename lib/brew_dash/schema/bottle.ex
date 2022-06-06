defmodule BrewDash.Schema.Bottle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bottles" do
    field :company, :string
    field :name, :string
    field :style, :string
    field :vintage, :string
    field :purchased_at, :utc_datetime
    field :drunk_at, :utc_datetime
    field :size, :string
    field :quantity, :integer
    field :location, :string
    field :notes, :string

    timestamps()
  end

  @doc false
  def changeset(bottle, attrs) do
    bottle
    |> cast(attrs, [
      :company,
      :name,
      :style,
      :vintage,
      :purchased_at,
      :drunk_at,
      :size,
      :quantity,
      :location,
      :notes
    ])
    |> validate_required([:company, :name])
  end
end
