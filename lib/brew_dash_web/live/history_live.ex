defmodule BrewDashWeb.HistoryLive do
  use BrewDashWeb, :live_view
  import BrewDash.Brews.Display
  alias BrewDash.Brews.Brew

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch_brew_sessions(socket)}
  end

  defp fetch_brew_sessions(socket) do
    brews_by_year =
      Enum.chunk_by(Brew.all(), fn
        %{brewed_at: nil} -> 0
        %{brewed_at: date} -> date.year
      end)

    assign(socket, brew_sessions: brews_by_year)
  end

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
end
