defmodule BrewDash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    migrate()

    children = [
      # Start the Ecto repository
      BrewDash.Repo,
      # Start the Telemetry supervisor
      BrewDashWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BrewDash.PubSub},
      # Start the Endpoint (http/https)
      BrewDashWeb.Endpoint,
      # Start the GrainFather Sync Scheduler
      BrewDash.Tasks.SyncGrainFatherServer
      # Start a worker by calling: BrewDash.Worker.start_link(arg)
      # {BrewDash.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BrewDash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  if Mix.env() == :prod do
    defp migrate, do: BrewDash.Release.migrate()
  else
    defp migrate, do: nil
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BrewDashWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
