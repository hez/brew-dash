defmodule BrewDashWeb.HistoryLive do
  use BrewDashWeb, :live_view
  import BrewDash.Brews.Display
  alias BrewDash.Brews.Brew
  alias BrewDash.Schema

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch_brew_sessions(socket)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h2>Brew Session History</h2>
      <table class="table table-sm table-bordered table-striped">
        <thead>
          <tr class="table-primary">
            <th scope="col">Brewed</th>
            <th scope="col">Batch</th>
            <th scope="col">Name</th>
          </tr>
        </thead>
        <tbody>
          <.years_brew_sessions
            :for={brews <- @brew_sessions}
            brews={brews}
            first={first_with_brewed_at(brews)}
          />
        </tbody>
      </table>
    </div>
    """
  end

  attr :brews, :list, required: true
  attr :first, Schema.Brew, default: nil

  def years_brew_sessions(assigns) do
    ~H"""
    <tr :if={@first}>
      <th><%= @first.brewed_at.year %></th>
      <th></th>
      <th></th>
    </tr>

    <tr :for={brew <- @brews}>
      <td class="ps-4">
        <%= brew |> brewed_at!() |> month_name() %> <%= brew |> brewed_at!() |> Map.get(:day) %>
      </td>
      <td>
        <%= brew.batch_number %>
      </td>
      <td>
        <%= name(brew) %>
      </td>
    </tr>
    """
  end

  defp fetch_brew_sessions(socket) do
    brews_by_year =
      Enum.chunk_by(Brew.all(), fn
        %{brewed_at: nil} -> 0
        %{brewed_at: date} -> date.year
      end)

    assign(socket, brew_sessions: brews_by_year)
  end

  def month_name(%{month: month}), do: month_name(month)
  def month_name(nil), do: nil
  def month_name(1), do: "Jan"
  def month_name(2), do: "Feb"
  def month_name(3), do: "Mar"
  def month_name(4), do: "Apr"
  def month_name(5), do: "May"
  def month_name(6), do: "Jun"
  def month_name(7), do: "Jul"
  def month_name(8), do: "Aug"
  def month_name(9), do: "Sep"
  def month_name(10), do: "Oct"
  def month_name(11), do: "Nov"
  def month_name(12), do: "Dec"

  defp first_with_brewed_at(brews), do: Enum.find(brews, fn brew -> brew.brewed_at != nil end)
end
