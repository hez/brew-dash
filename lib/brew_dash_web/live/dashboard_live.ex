defmodule BrewDashWeb.DashboardLive do
  use BrewDashWeb, :live_view
  require Logger
  alias BrewDash.Brews.Brew
  alias BrewDash.Tasks.SyncGrainFather

  @order_by_status [:serving, :conditioning, :fermenting, :planning, :brewing, :completed]

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: SyncGrainFather.subscribe(:brew_sessions)

    socket =
      socket
      |> assign_status(params)
      |> fetch_brew_sessions()

    {:ok, socket}
  end

  @impl true
  def handle_info(:synced, socket) do
    Logger.info("brews sync notification")
    {:noreply, fetch_brew_sessions(socket)}
  end

  defp assign_status(socket, %{"status" => status}), do: assign(socket, statuses: [status])
  defp assign_status(socket, _), do: assign(socket, statuses: [:serving, :conditioning])

  defp fetch_brew_sessions(socket) do
    brew_sessions =
      socket.assigns.statuses
      |> Brew.all_with_statuses()
      |> Enum.sort(&brew_session_sort/2)

    assign(socket, brew_sessions: brew_sessions)
  end

  defp brew_session_sort(b1, b2) do
    Enum.find_index(@order_by_status, &(&1 == b1.status)) <=
      Enum.find_index(@order_by_status, &(&1 == b2.status))
  end
end
