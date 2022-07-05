defmodule BrewDashWeb.LiveDashboardComponents do
  import Phoenix.LiveView.Helpers

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
          <%= assigns[:tip] %>
        </span>
        <div class="w-3 h-3 -mt-2 rotate-45 bg-gray-600"></div>
      </div>
    </div>
    """
  end
end
