defmodule BrewDash.Tasks.SyncGrainFatherServer do
  use GenServer
  require Logger
  alias BrewDash.Tasks

  # period of 1hr default
  @defaults [period: 30 * 60 * 1000, full_sync_every: 2 * 24]
  @full_sync_page_limit 100
  @name __MODULE__

  def start_link(state \\ []), do: GenServer.start_link(@name, state, name: @name)

  @impl true
  def init(opts) do
    opts = Keyword.merge(@defaults, opts)

    state = %{
      period: Keyword.get(opts, :period),
      full_sync_counter: 1,
      full_sync_every: Keyword.get(opts, :full_sync_every),
      timer_ref: nil
    }

    {:ok, schedule(state)}
  end

  def sync_now(full_sync \\ false, pid \\ @name) when is_boolean(full_sync) do
    sync_limit = if full_sync, do: @full_sync_page_limit, else: 1
    Process.send(pid, {:sync, sync_limit}, [:noconnect, :nosuspend])
  end

  @impl true
  def handle_info({:sync, sync_limit}, state) do
    Logger.debug("sync tick #{inspect(state)}")
    Process.cancel_timer(state.timer_ref)
    state = schedule(state)

    # Sync!
    Tasks.SyncGrainFather.sync!(sync_limit)

    {:noreply, %{state | full_sync_counter: next_sync_counter(state)}}
  end

  def schedule(%{period: period} = state) do
    ref = Process.send_after(self(), {:sync, get_sync_limit(state)}, period)
    %{state | timer_ref: ref}
  end

  defp get_sync_limit(state) when state.full_sync_counter >= state.full_sync_every,
    do: @full_sync_page_limit

  defp get_sync_limit(_), do: 1

  defp next_sync_counter(state) when state.full_sync_counter >= state.full_sync_every, do: 1
  defp next_sync_counter(state), do: state.full_sync_counter + 1
end
