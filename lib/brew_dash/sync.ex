defmodule BrewDash.Sync do
  @topics %{
    brew_sessions: "sync_brew_sessions_update"
  }

  def subscribe(topic), do: Phoenix.PubSub.subscribe(BrewDash.PubSub, topic_name(topic))
  def topic_name(name), do: @topics[name]

  def broadcast(topic, event),
    do: Phoenix.PubSub.broadcast(BrewDash.PubSub, topic_name(topic), event)
end
