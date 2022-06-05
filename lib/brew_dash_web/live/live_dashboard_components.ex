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
      <div class="py-1 px-4 rounded-full bg-dull-blue font-bold text-m border-blue-800">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
