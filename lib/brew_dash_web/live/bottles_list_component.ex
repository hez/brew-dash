defmodule BrewDashWeb.BottlesListComponent do
  use BrewDashWeb, :live_component

  require Logger
  alias BrewDash.Bottles.Bottle

  @filterable_keys ["company", "location"]

  @impl true
  def update(assigns, socket) do
    filters = allowed_filters(assigns[:filter] || %{})

    socket =
      socket
      |> assign(filter: filters)
      |> assign(actions: assigns[:actions] || [])
      |> assign(title: assigns[:title] || [])
      |> assign(bottles: fetch_bottles(filters))

    {:ok, socket}
  end

  @impl true
  def handle_event("filter", params, socket) do
    filters = allowed_filters(params)

    socket =
      socket
      |> assign(bottles: fetch_bottles(filters))
      |> assign(filter: filters)

    {:noreply, socket}
  end

  def filter_type(%{filter: f}), do: f |> Enum.at(0) |> elem(0) |> String.capitalize()
  def filter_value(%{filter: f}), do: f |> Enum.at(0) |> elem(1)

  def filter_applied?(nil), do: false
  def filter_applied?(%{} = params) when map_size(params) == 0, do: false
  def filter_applied?(_), do: true

  defp fetch_bottles(%{"company" => company}), do: Bottle.cellared(company: company)
  defp fetch_bottles(%{"location" => location}), do: Bottle.cellared(location: location)
  defp fetch_bottles(_), do: Bottle.cellared()

  defp allowed_filters(params), do: Map.take(params, @filterable_keys)
end
