# adaptive batching mechanism
defmodule Backpressure do
  use GenServer

  @impl true
  def init(_arg) do
    in_q = []
    {:ok, in_q}
  end

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def insert(element) do
    GenServer.cast(Backpressure, {:insert, element})
  end

  def insert_users(user) do
    GenServer.cast(Backpressure, {:insert_users, user})
  end

  @impl true
  def handle_cast({:insert, element}, q) do
    up_q = [element | q]
    if Enum.count(up_q) >= 128 do
      GenServer.cast(__MODULE__, :batch)
    end

    {:noreply, up_q}
  end

  @impl true
  def handle_cast({:insert_users, user}, q) do
    up_q = [user | q]
    if Enum.count(up_q) >= 128 do
      GenServer.cast(__MODULE__, :batch_user)
    end

    {:noreply, up_q}
  end

  @impl true
  def handle_cast(:batch, q) do
    spawn(fn ->
      Enum.each(q, fn element ->
        load(element, "tweets")
      end)
    end)
    {:noreply, []}
  end

  @impl true
  def handle_cast(:batch_user, q) do
    spawn(fn ->
      Enum.each(q, fn user ->
        load(user, "users")
      end)
    end)
    {:noreply, []}
  end

  def load(message, coll) do
    {:ok, top} = Mongo.start_link(url: "mongodb://localhost:27017/rtp-tweets")
    Mongo.insert_one!(top, coll, message)
  end

end
