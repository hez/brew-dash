defmodule BrewDash.Brews.Display do
  alias BrewDash.Schema.Brew
  alias BrewDash.Schema.Recipe
  alias BrewDashWeb.Router.Helpers, as: Routes

  @default_image "/images/default_brew.jpg"

  def image_url(%Brew{recipe: recipe}) when recipe == nil or recipe.image_url == nil,
    do: Routes.static_path(BrewDashWeb.Endpoint, @default_image)

  def image_url(%Brew{recipe: %Recipe{image_url: image_url}}), do: image_url

  def display_name(%Brew{} = brew) do
    name =
      [display_recipe_name(brew.recipe), display_brew_name(brew)]
      |> Enum.reject(&is_nil/1)
      |> Enum.join(" - ")

    [name, display_batch_number(brew)] |> Enum.reject(&is_nil/1) |> Enum.join(" ")
  end

  def display_recipe_name(nil), do: nil
  def display_recipe_name(%Recipe{name: name}), do: name

  def display_brew_name(%Brew{recipe: nil, name: nil}), do: "unknown"
  def display_brew_name(%Brew{recipe: nil, name: name}), do: name
  def display_brew_name(%Brew{recipe: %_{name: name}, name: name}), do: nil
  def display_brew_name(%Brew{name: name}), do: name

  def display_batch_number(%Brew{batch_number: bn}) when is_binary(bn), do: "(##{bn})"
  def display_batch_number(_), do: nil

  def status_badge(%Brew{status: :serving}), do: "ON TAP"
  def status_badge(%Brew{status: :conditioning}), do: "ON DECK"
  def status_badge(%Brew{status: status}), do: status |> to_string() |> String.upcase()

  def brewed_at!(%Brew{brewed_at: nil}), do: nil
  def brewed_at!(%Brew{brewed_at: brewed_at}), do: DateTime.shift_zone!(brewed_at, time_zone())

  defp time_zone, do: Application.get_env(:brew_dash, :time_zone)
end
