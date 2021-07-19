defmodule BrewDash.Repo.Migrations.AddSourceToBrews do
  use Ecto.Migration

  def change do
    alter table(:brews) do
      add :source, :string
      add :source_id, :string
    end

    alter table(:recipes) do
      add :source, :string
      add :source_id, :string
    end

    create index(:brews, [:source])
    create index(:brews, [:source_id])
    create unique_index(:brews, [:source, :source_id])

    create index(:recipes, [:source])
    create index(:recipes, [:source_id])
    create unique_index(:recipes, [:source, :source_id])
  end
end
