defmodule ApiTest do
  use ExUnit.Case, async: true
  doctest Api

  test "greets the world" do
    assert Api.hello() == :world
  end
end
