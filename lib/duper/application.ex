defmodule Duper.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Duper.Result,
      {Duper.PathFinder, "."},
      Duper.WorkerSupervisor,
      {Duper.Gatherer, 1}
    ]

    opts = [strategy: :one_for_all, name: Duper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
