defmodule BrewDash.Repo.Migrations.AddTapNumberToBrews do
  use Ecto.Migration

  def change do
    alter table(:brews) do
      add :tap_number, :string
    end
  end
end
