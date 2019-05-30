defmodule ExLife do
  @moduledoc """
  Documentation for ExLife.
  """
  use Application

  @boardChars %{
    alive: IO.ANSI.green_background() <> "   " <> IO.ANSI.reset(),
    dead: IO.ANSI.yellow_background() <> "   " <> IO.ANSI.reset(),
    reset: IO.ANSI.clear()
  }

  def determineNextBoard(board) do
    boardLength = length(board)
    board
    |> Enum.with_index
    |> Enum.map(fn({ row, index }) ->
      nextRow = if index == (boardLength - 1) do
        hd(board)
      else
        Enum.at(board, (index + 1))
      end

      prevRow = if index == 0 do
        Enum.at(board, (boardLength - 1))
      else
        Enum.at(board, (index - 1))
      end

      determineNextRow(row, prevRow, nextRow)
    end)
  end

  def determineNeighbors(cellIndex, row, prevRow, nextRow) do
    numCells = length(row)
    north = Enum.at(prevRow, cellIndex)
    south = Enum.at(nextRow, cellIndex)

    { northwest, west, southwest } = if cellIndex == 0 do
      columnIndex = numCells - 1
      {
        Enum.at(prevRow, columnIndex),
        Enum.at(row, columnIndex),
        Enum.at(nextRow, columnIndex)
      }
    else
      columnIndex = cellIndex - 1
      {
        Enum.at(prevRow, columnIndex),
        Enum.at(row, columnIndex),
        Enum.at(nextRow, columnIndex)
      }
    end

    { northeast, east, southeast } = if cellIndex == (numCells - 1) do
      {
        Enum.at(prevRow, 0),
        Enum.at(row, 0),
        Enum.at(nextRow, 0)
      }
    else
      columnIndex = cellIndex + 1
      {
        Enum.at(prevRow, columnIndex),
        Enum.at(row, columnIndex),
        Enum.at(nextRow, columnIndex)
      }
    end

    [ northwest, north, northeast, west, east, southwest, south, southeast ]
  end

  def determineNextRow(row, prevRow, nextRow) do
    row
    |> Enum.with_index
    |> Enum.map(fn ({ cell, index }) ->
      numAlive = determineNeighbors(index, row, prevRow, nextRow) |> Enum.count(&(&1 == true))
      cond do
        cell && (numAlive > 3 || numAlive < 2) -> false
        cell && (numAlive == 2 || numAlive == 3) -> true
        !cell && (numAlive == 3) -> true
        true -> false
      end
    end)
  end

  def drawBoard(board) do
    boardString = Enum.reduce(board, "", fn (row, acc) ->
      rowString = Enum.reduce(row, "",
        fn (cell, acc) -> acc <> if cell, do: @boardChars.alive, else: @boardChars.dead  end)
      acc <> "\n" <> rowString
    end)
    IO.puts(@boardChars.reset <> boardString)
  end

  def getBoard(boardSize) do
    (0..(boardSize - 1))
    |> Enum.map(fn _x -> ExLife.getRow(boardSize) end)
  end

  def getRow(rowSize) do
    (0..(rowSize - 1))
    |> Enum.map(fn _x -> Enum.random(0..1) == 1 end)
  end

  def go do
    iterate(getBoard(20))
  end

  def iterate(board) do
    drawBoard(board)
    :timer.sleep(250)
    iterate(determineNextBoard(board))
  end

  def start(_type, _args) do
    go
  end
end
