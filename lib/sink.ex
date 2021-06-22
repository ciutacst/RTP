defmodule Sink do
  use GenServer

  def start_link(Message) do
    GenServer.start(__MODULE__, Message, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    in_q = []
    {:ok, in_q}
  end

  @impl true
  def handle_cast({:message, Message}, _smth) do
    MyIO.my_inspect("ADDING ACTUAL TWEET")

   {:noreply, %{}}
  end

end
