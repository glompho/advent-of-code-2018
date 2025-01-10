defmodule AdventOfCode.Day20 do
  def factors(n) do
    Enum.reduce(1..(trunc(n ** 0.5) + 1), MapSet.new([1, n]), fn factor, acc ->
      if rem(n, factor) == 0 do
        MapSet.union(acc, MapSet.new([factor, div(n, factor)]))
      else
        acc
      end
    end)
  end

  def get_target(args) do
    args
    |> String.trim()
    |> String.to_integer()
  end

  def part1(args) do
    target = get_target(args)

    Stream.iterate(1, &(&1 + 1))
    |> Enum.find(fn n ->
      n
      |> factors()
      |> Enum.sum()
      |> then(&(&1 * 10 >= target))
    end)
  end

  def part2(args) do
    target = get_target(args)

    Stream.iterate(1, &(&1 + 1))
    |> Enum.find(fn n ->
      n
      |> factors()
      |> Enum.filter(&(div(n, &1) <= 50))
      |> Enum.sum()
      |> then(&(&1 * 11 >= target))
    end)
  end
end
