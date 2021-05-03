defmodule Duper.WorkerSupervisor do
  use DynamicSupervisor

  @me __MODULE__

  def start_link(_), do: DynamicSupervisor.start_link(__MODULE__, nil, name: @me)
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  def add_worker do
    {:ok, _} = DynamicSupervisor.start_child(@me, Duper.Worker)
  end
end
