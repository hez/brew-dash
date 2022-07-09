defmodule BrewDash.Repo.Migrations.AddArchivedToRecipe do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :is_archived, :boolean
    end
  end
end
