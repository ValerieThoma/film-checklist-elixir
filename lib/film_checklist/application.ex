defmodule FilmChecklist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FilmChecklistWeb.Telemetry,
      FilmChecklist.Repo,
      {DNSCluster, query: Application.get_env(:film_checklist, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FilmChecklist.PubSub},
      # Start a worker by calling: FilmChecklist.Worker.start_link(arg)
      # {FilmChecklist.Worker, arg},
      # Start to serve requests, typically the last entry
      FilmChecklistWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FilmChecklist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FilmChecklistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
