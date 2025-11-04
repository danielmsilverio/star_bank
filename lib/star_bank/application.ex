defmodule StarBank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      StarBankWeb.Telemetry,
      StarBank.Repo,
      {DNSCluster, query: Application.get_env(:star_bank, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: StarBank.PubSub},
      # Start a worker by calling: StarBank.Worker.start_link(arg)
      # {StarBank.Worker, arg},
      # Start to serve requests, typically the last entry
      StarBankWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StarBank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StarBankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
