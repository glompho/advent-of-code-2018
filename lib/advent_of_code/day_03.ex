defmodule AdventOfCode.Day03 do
  def part1(args) do
    args
    |> travel([[0, 0]])
    |> Enum.frequencies()
    |> Enum.count()
  end

  def travel(">" <> rest, [[x, y] | previous]) do
    travel(rest, [[x + 1, y], [x, y]] ++ previous)
  end

  def travel("<" <> rest, [[x, y] | previous]) do
    travel(rest, [[x - 1, y], [x, y]] ++ previous)
  end

  def travel("^" <> rest, [[x, y] | previous]) do
    travel(rest, [[x, y + 1], [x, y]] ++ previous)
  end

  def travel("v" <> rest, [[x, y] | previous]) do
    travel(rest, [[x, y - 1], [x, y]] ++ previous)
  end

  def travel("", acc) do
    acc
  end

  def part2(args) do
    ## Should probably have used String.graphemes and also split_with
    args
    |> String.to_charlist()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [x, y] -> {x, y} end)
    |> Enum.unzip()
    |> Tuple.to_list()
    |> Enum.flat_map(&travel(List.to_string(&1), [[0, 0]]))
    |> Enum.frequencies()
    |> Enum.count()
  end
end
