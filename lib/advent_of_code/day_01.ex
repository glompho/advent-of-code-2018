defmodule AdventOfCode.Day01 do
  def follow_path([], [{x, y} | rest], _), do: [{x, y} | rest]

  def follow_path([{direction, num} | rest], [{x, y} | rem_path], {dx, dy}) do
    {ndx, ndy} =
      case direction do
        "L" -> {dy, -dx}
        "R" -> {-dy, dx}
      end

    d = String.to_integer(num)
    new_visits = for i <- Range.new(d, 0, -1), do: {x + i * ndx, y + i * ndy}
    follow_path(rest, new_visits ++ rem_path, {ndx, ndy})
  end

  def parse(input) do
    input
    |> String.split([" ", ",", "\n"], trim: true)
    |> Enum.map(&String.split_at(&1, 1))
  end

  def part1(input) do
    input
    |> parse()
    |> follow_path([{0, 0}], {0, -1})
    |> hd()
    |> then(fn {row, col} -> abs(row) + abs(col) end)
  end

  def part2(input) do
    input
    |> parse()
    |> follow_path([{0, 0}], {0, -1})
    |> Enum.reverse()
    |> Enum.reduce_while(MapSet.new(), fn loc, acc ->
      if MapSet.member?(acc, loc) do
        {:halt, loc}
      else
        {:cont, MapSet.put(acc, loc)}
      end
    end)
    |> then(fn {row, col} -> abs(row) + abs(col) end)
  end
end
