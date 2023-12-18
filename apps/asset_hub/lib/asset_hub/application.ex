defmodule AssetHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AssetHub.Repo,
      {DNSCluster, query: Application.get_env(:asset_hub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AssetHub.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AssetHub.Finch}
      # Start a worker by calling: AssetHub.Worker.start_link(arg)
      # {AssetHub.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: AssetHub.Supervisor)
  end
end
