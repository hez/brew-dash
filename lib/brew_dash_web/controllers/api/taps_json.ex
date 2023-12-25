defmodule BrewDashWeb.API.TapsJSON do
  alias BrewDash.Brews

  @json_brew_attrs [
    :id,
    :abv,
    :batch_number,
    :brewed_at,
    :full_name,
    :image_url,
    :is_gf,
    :name,
    :recipe_name,
    :status,
    :status_badge,
    :tap_number
  ]

  @doc """
  """
  def index(%{taps: taps}) do
    taps = Enum.map(taps, &transform_brew/1)
    %{taps: taps}
  end

  defp transform_brew(brew) do
    brew
    |> Map.take(@json_brew_attrs)
    |> Map.put(:image_url, Brews.Display.image_url(brew))
    |> Map.put(:abv, Brews.abv(brew))
    |> Map.put(:full_name, Brews.Display.full_name(brew))
    |> Map.put(:recipe_name, Brews.Display.recipe_name(brew.recipe))
    |> Map.put(:is_gf, Brews.gf?(brew))
    |> Map.put(:status_badge, Brews.Display.status_badge(brew))
  end
end
