defmodule Duper.PathFinder do
  use GenServer

  @me __MODULE__

  def start_link(root), do: GenServer.start_link(@me, root, name: @me)
  def next_path, do: GenServer.call(@me, {:next})
  def init(path), do: DirWalker.start_link(path)

  def handle_call({:next}, _, walker) do
    path =
      case DirWalker.next(walker) do
        [path] -> path
        path -> path
      end

    {:reply, path, walker}
  end
end
