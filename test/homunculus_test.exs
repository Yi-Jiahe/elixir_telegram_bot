defmodule HomunculusTest do
  use ExUnit.Case
  doctest Homunculus

  test "greets the world" do
    assert Homunculus.hello() == :world
  end
end
