defmodule Receive do

  def conn() do
    {:ok, socket} = TCP.connect(:localhost, 17017)
    socket
  end

  def list(sok) do
    data = :gen_tcp.recv(sok, 0)
    :io.format(">>>>>>>>>>>>>>>>>>>>>>~n~p~n",[data])
  end

end
