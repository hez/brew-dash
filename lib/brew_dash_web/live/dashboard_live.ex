defmodule BrewDashWeb.DashboardLive do
  use BrewDashWeb, :live_view
  require Logger
  alias BrewDash.Brews.Brew

  @order_by_status [:serving, :conditioning, :fermenting, :planning, :brewing, :completed]

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: BrewDash.Sync.subscribe(:brew_sessions)

    socket =
      socket
      |> assign_status(params)
      |> fetch_brew_sessions()

    {:ok, socket}
  end

  @impl true
  def handle_info(:brew_sessions_updated, socket) do
    Logger.info("brews sync notification")
    {:noreply, fetch_brew_sessions(socket)}
  end

  defp assign_status(socket, %{"status" => status}), do: assign(socket, statuses: [status])
  defp assign_status(socket, _), do: assign(socket, statuses: [:serving, :conditioning])

  defp fetch_brew_sessions(socket) do
    brew_sessions =
      socket.assigns.statuses
      |> Brew.all_with_statuses()
      |> Enum.sort(&brew_sort_tap_number/2)
      |> Enum.sort(&brew_sort_status/2)

    assign(socket, brew_sessions: brew_sessions)
  end

  defp brew_sort_status(b1, b2) do
    Enum.find_index(@order_by_status, &(&1 == b1.status)) <=
      Enum.find_index(@order_by_status, &(&1 == b2.status))
  end

  defp brew_sort_tap_number(b1, b2) when is_binary(b1.tap_number) and is_binary(b2.tap_number) do
    case {Integer.parse(b1.tap_number), Integer.parse(b2.tap_number)} do
      {{b1_tn, ""}, {b2_tn, ""}} -> b1_tn <= b2_tn
      _ -> b1.tap_number <= b2.tap_number
    end
  end

  defp brew_sort_tap_number(_b1, _b2), do: false
end
