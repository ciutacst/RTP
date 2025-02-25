defmodule Connection do

  def start_link(url) do
    {:ok, _pid} = EventsourceEx.new(url, stream_to: self())
    getMessage()
  end

  def getMessage() do
      receive do
        Message -> GenServer.cast(Router, {:router, Message})
      end

      getMessage()
  end

 def child_spec(arg) do
   %{
     id: __MODULE__,
     start: {__MODULE__, :start_link, [opts]},
     type: :worker,
     restart: :permanent,
     shutdown: 200
   }
 end

end