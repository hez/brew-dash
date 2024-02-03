defmodule BrewDashWeb.TapsDashboardLive do
  use BrewDashWeb, :live_view
  import HomeDash.Provider, only: [handle_info_home_dash: 0]
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="justify-items-center p-4 gap-16">
      <.live_component
        module={HomeDashWeb.Cards}
        providers={[{BrewDash.DatabaseBrewProvider, []}]}
        id="brews"
      />
    </div>
    """
  end

  @impl true
  handle_info_home_dash()
end
