defmodule BrewDash.Repo.Migrations.CreateBrews do
  use Ecto.Migration

  def change do
    create table(:brews) do
      add :brewed_at, :utc_datetime
      add :fermentation_at, :utc_datetime
      add :final_gravity, :float
      add :name, :string
      add :notes, :text
      add :original_gravity, :float
      add :recipe_id, :integer
      add :status, :string
      add :tapped_at, :utc_datetime

      timestamps()
    end

    create index(:brews, [:recipe_id])
    create index(:brews, [:status])
    create index(:brews, [:name])
  end
end
