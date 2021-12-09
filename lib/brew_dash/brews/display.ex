defmodule BrewDash.Brews.Display do
  alias BrewDash.Schema.Brew
  alias BrewDash.Schema.Recipe
  alias BrewDashWeb.Router.Helpers, as: Routes

  @default_image "/images/default_brew.jpg"

  def image_url(%Brew{recipe: recipe}) when recipe == nil or recipe.image_url == nil,
    do: Routes.static_path(BrewDashWeb.Endpoint, @default_image)

  def image_url(%Brew{recipe: %Recipe{image_url: image_url}}), do: image_url

  def full_name(%Brew{} = brew) do
    [name(brew), batch_number(brew)] |> Enum.reject(&is_nil/1) |> Enum.join(" ")
  end

  def name(%Brew{} = brew) do
    [recipe_name(brew.recipe), brew_name(brew)] |> Enum.reject(&is_nil/1) |> Enum.join(" - ")
  end

  # TODO Move to BrewDash.Recipes.Display
  def recipe_name(nil), do: nil
  def recipe_name(%Recipe{name: name}), do: name
  def recipe_name(%Brew{recipe: recipe}), do: recipe_name(recipe)

  def brew_name(%Brew{name: "Batch"}), do: nil
  def brew_name(%Brew{recipe: nil, name: nil}), do: "unknown"
  def brew_name(%Brew{recipe: nil, name: name}), do: name
  def brew_name(%Brew{recipe: %_{name: name}, name: name}), do: nil
  def brew_name(%Brew{name: name}), do: name

  def batch_number(%Brew{batch_number: bn}) when is_binary(bn), do: "(##{bn})"
  def batch_number(_), do: nil

  def status_badge(%Brew{status: :serving}), do: "ON TAP"
  def status_badge(%Brew{status: :conditioning}), do: "ON DECK"
  def status_badge(%Brew{status: status}), do: status |> to_string() |> String.upcase()

  def brewed_at!(%Brew{brewed_at: nil}), do: nil
  def brewed_at!(%Brew{brewed_at: brewed_at}), do: DateTime.shift_zone!(brewed_at, time_zone())

  def brewed_date_iso!(%Brew{brewed_at: nil}), do: nil
  def brewed_date_iso!(brew), do: brew |> brewed_at!() |> DateTime.to_date() |> Date.to_iso8601()

  defp time_zone, do: Application.get_env(:brew_dash, :time_zone)
end
