defmodule BrewDash.Recipes.Recipe do
  alias BrewDash.Repo

  def upsert!(changeset), do: Repo.insert!(changeset, on_conflict: {:replace_all_except, [:id]})
end
