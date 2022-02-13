defmodule BrewDashWeb.Admin.CSVSyncLive do
  use BrewDashWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:recipes, accept: ~w(.csv), max_entries: 1)
      |> allow_upload(:brew_sessions, accept: ~w(.csv), max_entries: 1)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save-recipes", _params, socket) do
    results =
      consume_uploaded_entries(socket, :recipes, fn %{path: path}, _entry ->
        BrewDash.CSV.sync_recipes(path)
      end)

    socket =
      case List.first(results) do
        count when is_integer(count) -> put_flash(socket, :info, "Updated #{count} recipes")
        _ -> put_flash(socket, :error, "error")
      end

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("save-brew-sessions", _params, socket) do
    results =
      consume_uploaded_entries(socket, :brew_sessions, fn %{path: path}, _entry ->
        BrewDash.CSV.sync_brew_sessions(path)
      end)

    socket =
      case List.first(results) do
        count when is_integer(count) -> put_flash(socket, :info, "Updated #{count} brew sessions")
        _ -> put_flash(socket, :error, "error")
      end

    {:noreply, socket}
  end
end
