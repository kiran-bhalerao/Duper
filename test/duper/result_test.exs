defmodule Duper.ResultTest do
  use ExUnit.Case
  alias Duper.Result

  test "can add extries to the result" do
    Result.add_hash_for("path 1", 123)
    Result.add_hash_for("path 2", 345)
    Result.add_hash_for("path 3", 567)
    Result.add_hash_for("path 4", 123)
    Result.add_hash_for("path 5", 345)

    duplicates = Result.find_duplicates()

    assert length(duplicates) == 2
    assert ["path 1", "path 4"] in duplicates
    assert ["path 2", "path 5"] in duplicates
  end
end
