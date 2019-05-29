defmodule ExLifeTest do
  use ExUnit.Case
  doctest ExLife

  test "greets the world" do
    assert ExLife.hello() == :world
  end
end
