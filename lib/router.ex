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

    Enum.each(1..5, fn(_x) ->
      Registry.register(MyRegistry, my_workers, keys: :unique)
    end)

    connections = Registry.lookup(MyRegistry)
    next_index = RoundRobin.read_and_increment()

    {pid, _value = nil} = Enum.at(connections, rem(next_index, length(connections)))

    GenServer.cast(pid, {:worker, Message})
    {:noreply, state}
  end

end