defmodule RTP.Application do

  use Application

  @impl true
  def start(_type, _args) do
    
    children = [

      %{
        id: Sink,
        start: {Sink, :start_link, [""]}
      },

      %{
        id: EngWorker,
        start: {EngWorker, :start_link, [""]}
      },
      
      %{
        id: EngagementSupervisor,
        start: {EngagementSupervisor, :start_link, [""]}
      },
      %{
        id: Supervisor,
        start: {Supervisor, :start_link, [""]}
      },
      %{
        id: Router,
        start: {Router, :start_link, [""]}
      },
      %{
        id: Connection1,
        start: {Connection, :start_link, ["http://localhost:4000/tweets/1"]}
      },
      %{
        id: Connection2,
        start: {Connection, :start_link, ["http://localhost:4000/tweets/2"]}
      }

    ]

    opts = [strategy: :one_for_one, name: RTP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end