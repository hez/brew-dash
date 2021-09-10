defmodule BrewDashWeb.BrewCardComponent do
  use BrewDashWeb, :live_component

  import BrewDash.Brews.Display

  alias BrewDash.Schema.Brew
  alias BrewDash.Schema.Recipe

  @default_image "/images/default_brew.jpg"

  def tap_number_present?(%Brew{status: :serving, tap_number: tap_number})
      when is_binary(tap_number),
      do: String.length(tap_number) > 0

  def tap_number_present?(_), do: false

  def tap_number_badge(%Brew{tap_number: tap_number}) do
    case Integer.parse(tap_number) do
      {number, ""} -> "Tap #{number}"
      _ -> tap_number
    end
  end
end
