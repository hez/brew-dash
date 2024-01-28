defmodule BrewDashWeb.DashboardLive do
  use BrewDashWeb, :live_view

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="full-w p-8">
      <ul class="px-8">
        <li><.link patch={~p"/taps"} class="py-2 text-blue-700">On Tap</.link></li>
        <li><.link patch={~p"/history"} class="py-2 text-blue-700">Brew History</.link></li>
        <li><.link patch={~p"/bottles"} class="py-2 text-blue-700">Bottles in Cellar</.link></li>
      </ul>
    </div>

    <div class="full-w p-8">
      <h1 class="font-bold text-2xl">About</h1>
      <div class="py-2">
        BrewDash is a quick way to sync your GrainFather brew history to a convient dashboard.
        You can find the source code at
        <.link navigate="https://github.com/hez/brew_dash" class="py-2 text-blue-700">
          github.com/hez/brew_dash
        </.link>
      </div>
    </div>
    """
  end
end
