defmodule BrewDash.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :image_url, :text

      timestamps()
    end
  end
end
