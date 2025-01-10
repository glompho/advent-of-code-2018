defmodule AdventOfCode.Day01 do
  def part1(args) do
    [Regex.scan(~r/\(/, args), Regex.scan(~r/\)/, args)]
    |> Enum.map(&Enum.count/1)
    |> then(fn [a, b] -> a - b end)
  end

  def part2(args) do
    got(args, 0, 0)
  end

  def got(<<"(", rest::binary>>, floor, steps) do
    got(rest, floor + 1, steps + 1)
  end

  def got(<<")"::utf8, _::binary>>, 0, steps) do
    steps + 1
  end

  def got(<<")"::utf8, rest::binary>>, floor, steps) do
    got(rest, floor - 1, steps + 1)
  end
end
