defmodule Duper.Gatherer do
  use GenServer
  @me __MODULE__

  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: @me)
  end

  def done, do: GenServer.cast(@me, :done)
  def result(path, hash), do: GenServer.cast(@me, {:result, path, hash})

  def init(worker_count) do
    Process.send_after(self(), :kick_off, 0)
    {:ok, worker_count}
  end

  def handle_info(:kick_off, worker_count) do
    1..worker_count
    |> Enum.each(fn _ -> Duper.WorkerSupervisor.add_worker() end)

    {:noreply, worker_count}
  end

  def handle_cast({:result, path, hash}, worker_count) do
    Duper.Result.add_hash_for(path, hash)
    {:noreply, worker_count}
  end

  def handle_cast(:done, _worker_count = 1) do
    report_result()
    System.halt(0)
  end

  def handle_cast(:done, worker_count) do
    {:noreply, worker_count - 1}
  end

  defp report_result do
    IO.puts("Results:\n")

    Duper.Result.find_duplicates()
    |> Enum.each(&IO.inspect/1)
  end
end
