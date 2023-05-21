defmodule BrewDashWeb.LiveDashboardComponents do
  use Phoenix.Component
  alias BrewDashWeb.Router.Helpers, as: Routes

  attr :align, :atom, default: :right
  attr :class, :string, default: nil
  slot(:inner_block, required: true)

  def floating_pill(assigns) do
    assigns =
      assign_new(assigns, :position, fn assigns ->
        case assigns.align do
          :left -> "left-4"
          _ -> "right-4"
        end
      end)

    ~H"""
    <div class={[
      "absolute top-4 py-1 px-4 rounded-full font-bold text-m bg-blue-200 dark:bg-dull-blue dark:border-blue-800",
      @class,
      @position
    ]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :tip, :string, required: true
  slot(:inner_block, required: true)

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
  """
  attr :tip, :string, required: true
  attr :image, :string, required: true
  attr :class, :string, default: nil

  def icon_with_tool_tip(assigns) do
    assigns =
      assigns
      |> assign_new(:width, fn -> "18px" end)
      |> assign_new(:image_src, fn %{image: img} ->
        Routes.static_path(BrewDashWeb.Endpoint, "/images/#{img}")
      end)

    ~H"""
    <.tool_tip tip={@tip}>
      <img src={@image_src} class={["w-5", @class]} alt={@tip} />
    </.tool_tip>
    """
  end

  attr :tip, :string, required: true
  attr :class, :string, default: nil

  def icon_gf(assigns) do
    ~H"""
    <svg
      fill="#000000"
      height="800px"
      width="800px"
      version="1.1"
      id="Capa_1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      viewBox="0 0 1125.628 1125.628"
      xml:space="preserve"
      class={["w-8 h-8", @class]}
    >
      <g>
        <path d="M562.812,0.002C252.476,0.002,0,252.478,0,562.814s252.476,562.812,562.812,562.812
        c310.34,0,562.816-252.476,562.816-562.812S873.152,0.002,562.812,0.002z M549.519,701.492c-14,15.033-28.964,28.403-52.992,40.11
        c-24.032,11.711-54.35,17.564-91.051,17.564c-46.662,0-85.943-14.504-115.476-43.517c-29.537-29.009-45.481-66.672-45.481-112.986
        v-79.694c0-46.139,15.398-83.758,43.801-112.856c28.398-29.099,65.568-43.648,110.311-43.648
        c46.487,0,82.395,11.318,107.126,33.948c24.729,22.635,37.507,52.898,38.031,89.77l-0.374,2.081h-72.092
        c-1.401-22-7.864-36.816-19.399-48.613c-11.534-11.796-28.402-17.949-50.594-17.949c-23.422,0-41.642,8.909-55.969,26.981
        c-14.332,18.073-20.841,41.207-20.841,69.667v80.144c0,28.984,6.77,52.512,21.627,70.585
        c14.853,18.072,34.539,27.104,59.705,27.104c17.826,0,32.671-1.827,43.51-5.489c10.834-3.658,16.159-8.188,25.159-13.591v-69.838
        h-71v-53h146V701.492z M880.519,430.263h-190v106h163v57h-163v159h-75v-379h265V430.263z" />
      </g>
    </svg>
    """
  end
end
