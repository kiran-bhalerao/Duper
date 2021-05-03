defmodule Duper.Result do
  # use GenServer

  # def start_link(_) do
  #   GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  # end

  # def add_hash_for(path, hash), do: GenServer.cast(__MODULE__, {:add, path, hash})
  # def find_duplicates, do: GenServer.call(__MODULE__, :find_duplicates)

  # def init(_), do: {:ok, %{}}

  # def handle_cast({:add, path, hash}, result) do
  #   result = Map.update(result, hash, [path], fn existing -> [path | existing] end)

  #   {:noreply, result}
  # end

  # def handle_call(:find_duplicates, _, result) do
  #   duplicates = hash_with_more_than_one_path(result)
  #   {:reply, duplicates, result}
  # end

  # defp hash_with_more_than_one_path(result) do
  #   result
  #   |> Enum.filter(fn {_, paths} -> length(paths) > 1 end)
  #   |> Enum.map(fn t -> Enum.sort(elem(t, 1)) end)
  # end

  use Agent

  def start_link(_), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  def add_hash_for(path, hash) do
    Agent.update(__MODULE__, fn result ->
      Map.update(result, hash, [path], fn existing -> [path | existing] end)
    end)
  end

  def find_duplicates do
    Agent.get(__MODULE__, fn result -> result end)
    |> Enum.filter(fn {_, paths} -> length(paths) > 1 end)
    |> Enum.map(fn t -> Enum.sort(elem(t, 1)) end)
  end
end
