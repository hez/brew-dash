defmodule BrewDashWeb.Admin.BrewSessionsLive do
  use BrewDashWeb, :live_view
  import BrewDash.Brews.Display
  alias BrewDash.Brews.Brew

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch_brew_sessions(socket)}
  end

  @impl true
  def handle_event("delete", %{"value" => id}, socket) do
    id |> String.to_integer() |> Brew.delete!()

    socket =
      socket
      |> put_flash(:info, "Deleted brew session with id: #{id}")
      |> fetch_brew_sessions()

    {:noreply, socket}
  end

  defp fetch_brew_sessions(socket), do: assign(socket, brew_sessions: Brew.all())
end
