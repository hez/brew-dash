defmodule BrewDash.Schema.Brew do
  use Ecto.Schema
  import Ecto.Changeset
  alias BrewDash.Schema.Recipe

  schema "brews" do
    field :brewed_at, :utc_datetime
    field :fermentation_at, :utc_datetime
    field :name, :string
    field :notes, :string

    field :status, Ecto.Enum,
      values: [:brewed, :fermenting, :conditioning, :serving, :completed],
      default: :brewed

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
      :name,
      :brewed_at,
      :fermentation_at,
      :tapped_at,
      :status,
      :notes,
      :original_gravity,
      :final_gravity
    ])
    |> validate_required([:name, :brewed_at, :status])
  end
end
