defmodule BrewDashWeb.API.TapsJSON do
  alias BrewDash.Brews

  @doc """
  """
  def index(%{taps: taps}) do
    %{taps: Enum.map(taps, &Brews.to_map/1)}
  end
end
