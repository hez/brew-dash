defmodule BrewDashWeb.LiveDashboardComponents do
  import Phoenix.LiveView.Helpers
  import Phoenix.LiveView, only: [assign_new: 3]
  alias BrewDashWeb.Router.Helpers, as: Routes

  def floating_pill(assigns) do
    position =
      case assigns.align do
        :left -> "left-4"
        _ -> "right-4"
      end

    ~H"""
    <div class={"absolute top-4 #{position}"}>
      <div class="py-1 px-4 rounded-full font-bold text-m bg-blue-200 dark:bg-dull-blue dark:border-blue-800">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def tool_tip(assigns) do
    ~H"""
    <div class="relative flex flex-col items-center group">
      <%= render_slot(@inner_block) %>
      <div class="absolute bottom-0 flex flex-col items-center hidden mb-6 group-hover:flex">
        <span class="relative z-10 p-2 text-xs leading-none text-white whitespace-no-wrap bg-gray-600 shadow-lg rounded-md">
          <%= @tip %>
        </span>
        <div class="w-3 h-3 -mt-2 rotate-45 bg-gray-600"></div>
      </div>
    </div>
    """
  end

  @doc """
  Displays an icon relative to the static `/images/` path with a tool tip.
  Requires the following assignments
    - tip
    - image
  """
  def icon_with_tool_tip(assigns) do
    assigns =
      assigns
      |> assign_new(:width, fn -> "18px" end)
      |> assign_new(:image_src, fn %{image: img} ->
        Routes.static_path(BrewDashWeb.Endpoint, "/images/#{img}")
      end)

    ~H"""
    <.tool_tip tip={@tip}>
      <img src={@image_src} class="w-5" alt={@tip} />
    </.tool_tip>
    """
  end
end
