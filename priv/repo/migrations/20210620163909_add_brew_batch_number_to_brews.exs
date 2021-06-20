defmodule BrewDash.Repo.Migrations.AddBrewBatchNumberToBrews do
  use Ecto.Migration

  def change do
    alter table(:brews) do
      add :batch_number, :string
    end
  end
end
