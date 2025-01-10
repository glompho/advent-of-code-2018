defmodule AdventOfCode.Day17 do
  def solve(_jugs, used, 0) do
    [used]
  end

  def solve([], _used, _rem_eggnog) do
    []
  end

  def solve([jug | rem_jugs], used, eggnog) do
    cond do
      jug == eggnog ->
        [[jug | used] | solve(rem_jugs, used, eggnog)]

      jug < eggnog ->
        solve(rem_jugs, [jug | used], eggnog - jug) ++ solve(rem_jugs, used, eggnog)

      true ->
        solve(rem_jugs, used, eggnog)
    end
  end

  def part1(args, eggnog \\ 150) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> solve([], eggnog)
    |> Enum.count()
  end

  def part2(args, eggnog \\ 150) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> solve([], eggnog)
    |> Enum.map(&length/1)
    |> Enum.frequencies()
    |> Enum.min_by(&elem(&1, 0))
    |> elem(1)
  end
end
