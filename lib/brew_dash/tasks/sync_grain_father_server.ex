defmodule BrewDash.Tasks.SyncGrainFatherServer do
  use GenServer
  require Logger
  alias BrewDash.Tasks

  # period of 1hr default
  @defaults [period: 30 * 60 * 1000, full_sync_every: 2 * 24]
  @full_sync_page_limit 100

  def start_link(state \\ []), do: GenServer.start_link(__MODULE__, state)

  @impl true
  def init(opts) do
    opts = Keyword.merge(@defaults, opts)

    state = %{
      period: Keyword.get(opts, :period),
      full_sync_counter: 1,
      full_sync_every: Keyword.get(opts, :full_sync_every)
    }

    {:ok, schedule(state)}
  end

  @impl true
  def handle_info(:sync, state) do
    Logger.debug("sync tick #{inspect(state)}")
    state = schedule(state)

    # Sync!
    state
    |> get_sync_limit()
    |> Tasks.SyncGrainFather.sync!()

    {:noreply, %{state | full_sync_counter: next_sync_counter(state)}}
  end

  def schedule(%{period: period} = state) do
    Process.send_after(self(), :sync, period)
    state
  end

  defp get_sync_limit(state) when state.full_sync_counter >= state.full_sync_every,
    do: @full_sync_page_limit

  defp get_sync_limit(_), do: 1

  defp next_sync_counter(state) when state.full_sync_counter >= state.full_sync_every, do: 1
  defp next_sync_counter(state), do: state.full_sync_counter + 1
end
