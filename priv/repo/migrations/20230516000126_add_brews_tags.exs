defmodule BrewDash.Repo.Migrations.AddBrewsTags do
  use Ecto.Migration

  def change do
    alter table(:brews) do
      add :tags, {:array, :string}
    end
  end
end
