defmodule BrewDash.Schema.Brew do
  use Ecto.Schema
  import Ecto.Changeset
  alias BrewDash.Schema.Recipe

  @type t :: %__MODULE__{}

  @exportable_attributes [
    :batch_number,
    :brewed_at,
    :fermentation_at,
    :final_gravity,
    :image_url,
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
    field :image_url, :string
    field :name, :string
    field :notes, :string
    field :source, :string
    field :source_id, :string
    field :tap_number, :string
    field :tags, {:array, :string}, default: []

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
      :image_url,
      :name,
      :notes,
      :original_gravity,
      :recipe_id,
      :status,
      :tap_number,
      :tapped_at,
      :tags
    ])
    |> validate_required([:status])
    |> trim_array(:tags)
    |> sort_array(:tags)
  end

  def source_changeset(brew, attrs) do
    brew
    |> cast(attrs, [:source, :source_id])
    |> changeset(attrs)
    |> unique_constraint([:source, :source_id])
  end

  @doc """
  When working with a field that is an array of strings, this
  function sorts the values in the array.
  """
  def sort_array(changeset, field), do: update_change(changeset, field, &Enum.sort(&1))

  @doc """
  Remove the blank value from the array.
  """
  def trim_array(changeset, field, blank \\ "") do
    update_change(changeset, field, &Enum.reject(&1, fn item -> item == blank end))
  end
end
