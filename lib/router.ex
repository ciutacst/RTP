defmodule Router do
  use GenServer

  def start_link(Message) do
    GenServer.start_link(__MODULE__, Message, name: __MODULE__)
  end

  @impl true
  def init(Message) do
    {:ok, Message}
  end

  @impl true
  def handle_cast({:router, Message}, state) do


    my_workers = Supervisor.addWorker(Message)

    DynamicSupervisor.start_worker(message)
    DynamicSupervisor.cast_message(message)

    GenServer.cast(Sink, {:message, message})

    {:noreply, state}
  end

end
