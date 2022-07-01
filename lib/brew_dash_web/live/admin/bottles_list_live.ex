defmodule BrewDashWeb.Admin.BottlesListLive do
  use BrewDashWeb, :live_view
  alias BrewDash.Bottles.Bottle
  require Logger

  @impl true
  def mount(params, _session, socket), do: {:ok, assign(socket, filter: params)}

  @impl true
  def handle_event("remove", params, socket) do
    bottle = Bottle.get!(params["id"])

    case Bottle.remove(bottle) do
      {:ok, bottle} ->
        socket =
          socket
          |> put_flash(:info, "Removed bottle: #{bottle.company} - #{bottle.name}")
          |> push_redirect(to: Routes.live_path(socket, __MODULE__), replace: true)

        {:noreply, socket}

      {:error, msg} ->
        socket = put_flash(socket, :error, "Failed: #{inspect(msg)}")
        {:noreply, socket}
    end
  end
end
