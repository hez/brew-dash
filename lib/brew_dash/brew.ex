defmodule BrewDash.Brew do
  # https://en.wikipedia.org/wiki/Alcohol_by_volume#Practical_estimation_of_alcohol_content
  def abv(%{"original_gravity" => og, "final_gravity" => fg}), do: abv(og, fg)
  def abv(%{original_gravity: og, final_gravity: fg}), do: abv(og, fg)

  def abv(original_gravity, final_gravity)
      when is_float(original_gravity) and is_float(final_gravity),
      do: Float.round(131 * (original_gravity - final_gravity), 1)

  def abv(_, _), do: :unknown

  def abv1(%{"original_gravity" => og, "final_gravity" => fg}) when is_float(og) and is_float(fg),
    do: 105.0 / 0.79 * (og - fg) / fg

  def abv1(_), do: :unknown
end
