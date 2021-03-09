defmodule Supervisor do
  use DynamicSupervisor

  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker(message) do
    spec = {Worker, {message}}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def terminate_worker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end

  def send_msg(msg) do
    GenServer.cast(Worker, {:worker, msg})
  end
end