defmodule BrewDash.Repo.Migrations.AddCellarTable do
  use Ecto.Migration

  def change do
    create table(:bottles) do
      add :company, :string
      add :name, :string
      add :style, :string
      add :vintage, :string
      add :purchased_at, :utc_datetime
      add :drunk_at, :utc_datetime
      add :size, :string
      add :quantity, :integer
      add :location, :string
      add :notes, :text

      timestamps()
    end

    create index(:bottles, [:company])
    create index(:bottles, [:location])
  end
end
