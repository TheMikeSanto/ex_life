defmodule ExLifeTest do
  use ExUnit.Case
  doctest ExLife

  test "determineNextBoard generates a grid with the same size as the given grid" do
    board = ExLife.getBoard(5)
    nextBoard = ExLife.determineNextBoard(board)
    assert length(nextBoard) == 5
  end

  test "getBoard creates a grid with the given size" do
    assert length(ExLife.getBoard(5)) == 5
  end

  test "getRow creates a list with the given size" do
    assert length(ExLife.getRow(5)) == 5
  end
end
