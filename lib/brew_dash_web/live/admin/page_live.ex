defmodule BrewDashWeb.Admin.PageLive do
  use BrewDashWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
