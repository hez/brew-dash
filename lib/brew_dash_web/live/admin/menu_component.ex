defmodule BrewDashWeb.Admin.MenuComponent do
  use BrewDashWeb, :live_component

  alias BrewDash.Tasks

  @impl true
  def handle_event("start_sync", _, socket) do
    Tasks.SyncGrainFatherServer.sync_now(true)
    {:noreply, put_flash(socket, :info, "Sync manually triggered.")}
  end

  attr :link, :string, required: true
  attr :label, :string, required: true

  def menu_item(assigns) do
    ~H"""
    <li>
      <.link
        patch={@link}
        class="block py-2 pr-4 pl-3 text-gray-700 border-b border-gray-100 hover:bg-gray-50 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-gray-400 md:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent dark:border-gray-700"
      >
        <%= @label %>
      </.link>
    </li>
    """
  end
end
