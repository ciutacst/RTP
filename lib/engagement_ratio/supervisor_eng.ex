defmodule EngagementSupervisor do
  use DynamicSupervisor

  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # start worker process & add it to supervision
  def start_worker(message) do
    child_spec = %{id: EWorker, start: {EngWorker, :start_link, [message]}, restart: :temporary, shutdown: :brutal_kill}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  # terminate worker process and remove it from supervision
  def terminate_worker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end

  # check which processes are under supervision
  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  # check how many processes are under supervision
  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end

  def cast_message(message) do
    GenServer.cast(EWorker, {:e_worker, message})
  end

  def pid_children do
    Enum.map(DynamicSupervisor.which_children(__MODULE__), fn x ->
      Enum.at(Tuple.to_list(x), 1)
    end)
  end
end