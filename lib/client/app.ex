defmodule App.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Client}
    ]

    opts = [strategy: :one_for_one, max_restarts: 100, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
