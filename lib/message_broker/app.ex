defmodule MessageBroker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use MessageBroker.Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MessageBroker.Worker.start_link(arg)
      # {MessageBroker.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: MessageBroker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
