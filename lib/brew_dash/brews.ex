defmodule BrewDash.Brews do
  alias BrewDash.Brews
  alias BrewDash.Schema

  @brew_map_keys [
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

  # https://en.wikipedia.org/wiki/Alcohol_by_volume#Practical_estimation_of_alcohol_content
  @spec abv(map()) :: float()
  @spec abv(Schema.Brew.t()) :: float()
  def abv(%{"original_gravity" => og, "final_gravity" => fg}), do: abv(og, fg)
  def abv(%{original_gravity: og, final_gravity: fg}), do: abv(og, fg)

  @spec abv(float(), float()) :: float()
  def abv(original_gravity, final_gravity)
      when is_float(original_gravity) and is_float(final_gravity),
      do: Float.round(131 * (original_gravity - final_gravity), 1)

  @spec abv(any(), any()) :: :unknown
  def abv(_, _), do: :unknown

  def abv1(%{"original_gravity" => og, "final_gravity" => fg}) when is_float(og) and is_float(fg),
    do: 105.0 / 0.79 * (og - fg) / fg

  def abv1(_), do: :unknown

  @spec gf?(Schema.Brew.t()) :: boolean()
  def gf?(%_{tags: tags}) when is_list(tags), do: Enum.any?(tags, &(&1 == "gf"))
  def gf?(_), do: false

  @spec to_map(Schema.Brew.t(), boolean()) :: map()
  def to_map(brew, string_keys \\ false)

  def to_map(brew, false) do
    brew
    |> Map.take(@brew_map_keys)
    |> Map.put(:image_url, Brews.Display.image_url(brew))
    |> Map.put(:abv, Brews.abv(brew))
    |> Map.put(:full_name, Brews.Display.full_name(brew))
    |> Map.put(:recipe_name, Brews.Display.recipe_name(brew.recipe))
    |> Map.put(:is_gf, Brews.gf?(brew))
    |> Map.put(:status_badge, Brews.Display.status_badge(brew))
  end

  def to_map(brew, true),
    do: brew |> to_map(false) |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)
end
