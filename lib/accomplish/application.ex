defmodule Accomplish.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AccomplishWeb.Telemetry,
      Accomplish.Repo,
      {Oban, Application.fetch_env!(:accomplish, Oban)},
      {DNSCluster, query: Application.get_env(:accomplish, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Accomplish.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Accomplish.Finch},
      # Start a worker by calling: Accomplish.Worker.start_link(arg)
      # {Accomplish.Worker, arg},
      # Start to serve requests, typically the last entry
      AccomplishWeb.Endpoint,
      TwMerge.Cache
    ]

    children =
      if Mix.env() != :test do
        children ++ [Accomplish.Activities.EventHandler]
      else
        children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Accomplish.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AccomplishWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
