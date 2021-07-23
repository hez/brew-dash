defmodule BrewDash.Schema.Brew do
  use Ecto.Schema
  import Ecto.Changeset
  alias BrewDash.Schema.Recipe

  @exportable_attributes [
    :batch_number,
    :brewed_at,
    :fermentation_at,
    :final_gravity,
    :name,
    :notes,
    :original_gravity,
    :recipe,
    :source,
    :source_id,
    :status,
    :tap_number,
    :tapped_at
  ]
  @derive {Jason.Encoder, only: @exportable_attributes}

  schema "brews" do
    field :batch_number, :string
    field :brewed_at, :utc_datetime
    field :fermentation_at, :utc_datetime
    field :name, :string
    field :notes, :string
    field :source, :string
    field :source_id, :string
    field :tap_number, :string

    field :status, Ecto.Enum,
      values: [:planning, :brewing, :fermenting, :conditioning, :serving, :completed],
      default: :planning

    field :tapped_at, :utc_datetime
    field :original_gravity, :float
    field :final_gravity, :float

    belongs_to :recipe, Recipe

    timestamps()
  end

  @doc false
  def changeset(brew, attrs) do
    brew
    |> cast(attrs, [
      :batch_number,
      :brewed_at,
      :fermentation_at,
      :final_gravity,
      :name,
      :notes,
      :original_gravity,
      :status,
      :tap_number,
      :tapped_at
    ])
    |> validate_required([:status])
  end

  def source_changeset(brew, attrs) do
    brew
    |> cast(attrs, [:source, :source_id])
    |> changeset(attrs)
    |> unique_constraint([:source, :source_id])
  end
end
