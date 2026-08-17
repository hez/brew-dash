defmodule BrewDashWeb.Admin.BottlesListLive do
  use BrewDashWeb, :live_view
  alias BrewDash.Bottles.Bottle

  @impl true
  def mount(params, _session, socket), do: {:ok, assign(socket, filter: params)}

  @impl true
  def handle_info({:filter_changed, filter}, socket) do
    {:noreply, assign(socket, filter: filter)}
  end

  @impl true
  def handle_event("remove", params, socket) do
    bottle = Bottle.get!(params["id"])

    case Bottle.remove(bottle) do
      {:ok, bottle} ->
        socket =
          socket
          |> put_flash(:info, "Removed bottle: #{bottle.company} - #{bottle.name}")
          |> push_navigate(to: ~p"/admin/bottles?#{socket.assigns.filter}", replace: true)

        {:noreply, socket}

      {:error, msg} ->
        socket = put_flash(socket, :error, "Failed: #{inspect(msg)}")
        {:noreply, socket}
    end
  end
end
