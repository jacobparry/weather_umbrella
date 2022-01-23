defmodule WeatherTest do
  use ExUnit.Case, async: true
  doctest Weather

  test "greets the world" do
    assert Weather.hello() == :world
  end
end
