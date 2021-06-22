defmodule Client do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: :server)
  end

  def init(_state) do
    {:ok, socket} = TCP.connect(:localhost, 17017)
    :gen_tcp.controlling_process(socket, self())
    {:ok, socket}
  end

  def handle_info({:tcp, _socket, msg}, state) do
    %BaseMessages{header: _h, topic: _t, body: b} = Serializable.deserialize(msg)
    IO.puts "#{b}"

    {:noreply, state}
  end

  def handle_info(msg, state) do
    :io.format("_________________________~n~p~n_______________________________",[msg])

    {:noreply, state}
  end
end
