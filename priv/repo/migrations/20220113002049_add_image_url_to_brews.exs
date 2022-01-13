defmodule BrewDash.Repo.Migrations.AddImageUrlToBrews do
  use Ecto.Migration

  def change do
    alter table(:brews) do
      add :image_url, :string
    end
  end
end
