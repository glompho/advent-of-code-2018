defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [l, w, h] = line |> String.split("x") |> Enum.map(&String.to_integer/1)
      [smallest | rest] = [l * w, l * h, w * h] |> Enum.sort()
      3 * smallest + 2 * Enum.sum(rest)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b, c] = line |> String.split("x") |> Enum.map(&String.to_integer/1) |> Enum.sort()
      2 * a + 2 * b + a * b * c
    end)
    |> Enum.sum()
  end
end
