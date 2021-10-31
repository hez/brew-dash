defmodule BrewDash.CSV do
  require Logger
  alias BrewDash.CSV

  @spec sync_recipes(String.t()) :: {:ok, integer()} | {:error, String.t()}
  def sync_recipes(path) do
    results = CSV.Recipe.sync!(path)
    {:ok, Enum.count(results)}
  rescue
    error ->
      Logger.error("error parsing recipes #{inspect(error)}")
      {:error, "error"}
  end

  @spec sync_brew_sessions(String.t()) :: {:ok, integer()} | {:error, String.t()}
  def sync_brew_sessions(path) do
    results = CSV.Brew.sync!(path)
    {:ok, Enum.count(results)}
  rescue
    error ->
      Logger.error("error parsing brew sessions #{inspect(error)}")
      {:error, "error"}
  end
end
