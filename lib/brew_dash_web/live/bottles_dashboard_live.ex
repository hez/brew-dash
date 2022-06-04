defmodule BrewDashWeb.BottlesDashboardLive do
  use BrewDashWeb, :live_view
  require Logger
  alias BrewDash.Bottles.Bottle

  @impl true
  def mount(params, _session, socket) do
    socket = socket |> assign(bottles: fetch_bottles(params)) |> assign(filter: filter(params))
    {:ok, socket}
  end

  @impl true
  def handle_event("filter", params, socket) do
    socket = socket |> assign(bottles: fetch_bottles(params)) |> assign(filter: filter(params))
    {:noreply, socket}
  end

  def show_filter(%{filter: nil} = assigns), do: ~H""

  def show_filter(%{filter: {type, value}} = assigns) do
    ~H"""
    <div class="flex w-full p-8 justify-center">
      <button type="button" phx-click="filter" class="cursor-pointer px-2 rounded-full bg-blue-200">
        Full List
      </button>
      <div class="px-8">Filtering by <%= type %>: <%= value %></div>
    </div>
    """
  end

  def filter_applied?(%{filter: nil}), do: false
  def filter_applied?(_), do: true

  defp fetch_bottles(%{"company" => company}), do: Bottle.cellared(company: company)
  defp fetch_bottles(%{"location" => location}), do: Bottle.cellared(location: location)
  defp fetch_bottles(_), do: Bottle.cellared()

  defp filter(%{"company" => company}), do: {"Company", company}
  defp filter(%{"location" => location}), do: {"Location", location}
  defp filter(_), do: nil
end
