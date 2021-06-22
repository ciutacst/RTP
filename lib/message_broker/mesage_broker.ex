defmodule MessageBroker do
  use GenServer

  def start_link(socket) do
    GenServer.start_link(__MODULE__, [socket], name: :server)
  end

  def init(socket) do
    GenServer.cast(self(), :accept)
    {:ok, socket}
  end

  def handle_cast(:accept, [socket|_]) do
    {:ok, client} = :gen_tcp.accept(socket)
    :gen_tcp.controlling_process(client, self())
    {:noreply, socket}
  end

  def handle_cast(msg, socket) do
    IO.puts("Received #{msg}")
    {:noreply, socket}
  end

end
