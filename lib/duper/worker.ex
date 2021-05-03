defmodule Duper.Worker do
  use GenServer, restart: :transient
  @me __MODULE__

  def start_link(_), do: GenServer.start_link(@me, nil, name: @me)

  def init(_) do
    Process.send_after(self(), :do_one_file, 0)
    {:ok, nil}
  end

  def handle_info(:do_one_file, _) do
    Duper.PathFinder.next_path()
    |> add_result
  end

  defp add_result(nil) do
    Duper.Gatherer.done()
    {:stop, :normal, nil}
  end

  defp add_result(path) do
    Duper.Gatherer.result(path, hash_of_file(path))
    send(self(), :do_one_file)
    {:noreply, nil}
  end

  defp hash_of_file(path) do
    File.stream!(path, [], 1024 * 1024)
    |> Enum.reduce(
      :crypto.hash_init(:md5),
      fn block, hash ->
        :crypto.hash_update(hash, block)
      end
    )
    |> :crypto.hash_final()
  end
end
