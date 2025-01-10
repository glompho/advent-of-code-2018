defmodule AdventOfCode.Day14 do
  def ceil_div(a, b) when is_integer(a) and is_integer(b) and b != 0 do
    div(a + b - 1, b)
  end

  def race(args, n) do
    Regex.scan(~r/\d+/, args)
    |> Enum.map(fn [str] -> String.to_integer(str) end)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [speed, time, rest] ->
      main_time = div(n, time + rest) * speed * time
      rem_bit = min(rem(n, time + rest), time) * speed
      main_time + rem_bit
    end)
  end

  def part1(args, n \\ 2503) do
    race(args, n)
    |> Enum.max()
  end

  def part2(args, n \\ 2503) do
    Enum.reduce(1..n, %{}, fn second, acc ->
      results = race(args, second) |> Enum.with_index()

      winning_score =
        results
        |> Enum.max_by(fn {num, _index} -> num end)
        |> elem(0)

      winners =
        Enum.filter(results, fn {num, _index} -> num == winning_score end)

      Enum.reduce(winners, acc, fn {_, winner}, acc ->
        Map.update(acc, winner, 1, &(&1 + 1))
      end)
    end)
    |> Map.values()
    |> Enum.max()
  end
end
