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
  def handle_cast({:router, Message}, _states) do
    WorkerSupervisor.start_worker(Message)
    WorkerSupervisor.send_Message(Message)
    {:noreply, %{}}
 end

end