defmodule HerbexTest do
  use ExUnit.Case
  doctest Herbex

  test "greets the world" do
    assert Herbex.hello() == :world
  end
end
