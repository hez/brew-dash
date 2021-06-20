defmodule BrewDash.Tasks.SyncGrainFatherServer do
  use GenServer
  alias BrewDash.Tasks

  # period of 1hr default
  @defaults [period: 60 * 60 * 1000]

  def start_link(state \\ @defaults), do: GenServer.start_link(__MODULE__, state)

  @impl true
  def init(state) do
    schedule(state)

    {:ok, state}
  end

  @impl true
  def handle_info(:sync, state) do
    schedule(state)
    # Sync!
    Tasks.SyncGrainFather.sync!()
    {:noreply, state}
  end

  def schedule(state) do
    period = Keyword.get(state, :period)

    Process.send_after(self(), :sync, period)
  end
end
