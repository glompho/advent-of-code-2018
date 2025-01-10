defmodule AdventOfCode.Day10 do
  def one_step(input) do
    input
    |> Enum.chunk_by(fn {_amount, type} -> type end)
    |> Enum.flat_map(fn list ->
      [
        {1,
         list
         |> Enum.map(fn {amount, _type} -> amount end)
         |> Enum.sum()},
        {1,
         list
         |> hd()
         |> elem(1)}
      ]
    end)
  end

  def part1(input, steps \\ 40) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.chunk_by(& &1)
    |> Enum.map(fn [head | tail] -> {length(tail) + 1, String.to_integer(head)} end)
    |> Stream.iterate(&one_step/1)
    |> Enum.at(steps)
    |> Enum.count()
  end

  def part2(args, steps \\ 50) do
    part1(args, steps)
  end
end
