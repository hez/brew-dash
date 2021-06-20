defmodule BrewDashWeb.BrewCardComponent do
  use BrewDashWeb, :live_component

  alias BrewDash.Schema.Brew
  alias BrewDash.Schema.Recipe

  def image_url(socket, %Brew{recipe: %Recipe{image_url: nil}}),
    do: Routes.static_path(socket, "/images/default_brew.jpg")

  def image_url(_socket, %Brew{recipe: %Recipe{image_url: image_url}}), do: image_url

  def show_brew_name?(%Brew{recipe: recipe, name: name}), do: recipe.name != name
end
