defmodule BrewDash.Brews.Display do
  alias BrewDash.Schema.Brew
  alias BrewDash.Schema.Recipe
  alias BrewDashWeb.Router.Helpers, as: Routes

  @default_image "/images/default_brew.jpg"
  @order_by_status [:serving, :conditioning, :fermenting, :planning, :brewing, :completed]

  def image_url(%Brew{image_url: image_url}) when is_binary(image_url), do: image_url

  def image_url(%Brew{recipe: recipe}) when recipe == nil or recipe.image_url == nil,
    do: Routes.static_path(BrewDashWeb.Endpoint, @default_image)

  def image_url(%Brew{recipe: %Recipe{image_url: image_url}}), do: image_url

  def full_name(%Brew{} = brew) do
    [name(brew), batch_number(brew)] |> Enum.reject(&is_nil/1) |> Enum.join(" ")
  end

  def name(%Brew{} = brew) do
    [recipe_name(brew.recipe), brew_name(brew)] |> Enum.reject(&is_nil/1) |> Enum.join(" - ")
  end

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

  @spec sort_status(Brew.t(), Brew.t()) :: boolean()
  def sort_status(b1, b2) do
    Enum.find_index(@order_by_status, &(&1 == b1.status)) <=
      Enum.find_index(@order_by_status, &(&1 == b2.status))
  end

  @spec sort_tap_number(Brew.t(), Brew.t()) :: boolean()
  def sort_tap_number(b1, b2) when is_binary(b1.tap_number) and is_binary(b2.tap_number) do
    case {Integer.parse(b1.tap_number), Integer.parse(b2.tap_number)} do
      {{b1_tn, ""}, {b2_tn, ""}} -> b1_tn <= b2_tn
      _ -> b1.tap_number <= b2.tap_number
    end
  end

  def sort_tap_number(b1, _) when is_binary(b1.tap_number), do: true
  def sort_tap_number(_b1, _b2), do: false

  defp time_zone, do: Application.get_env(:brew_dash, :time_zone)
end
