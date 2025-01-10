defmodule AdventOfCode.Day05 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      cond do
        Enum.count(Regex.scan(~r/[aeiou]/, str)) <= 2 -> 0
        not Regex.match?(~r/(.)\1/, str) -> 0
        Regex.match?(~r/ab|cd|pq|xy/, str) -> 0
        true -> 1
      end
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      cond do
        not Regex.match?(~r/(..).*\1/, str) -> 0
        not Regex.match?(~r/(.).\1/, str) -> 0
        true -> 1
      end
    end)
    |> Enum.sum()
  end
end
