defmodule DbTest do
  use ExUnit.Case, async: true
  doctest Db

  test "greets the world" do
    assert Db.hello() == :world
  end
end
