defmodule AdventOfCode.Day25 do
  def next_number(n), do: rem(n * 252_533, 33_554_393)

  def triangle(n), do: div((n + 1) * n, 2)

  def part1(args) do
    [row, col] =
      Regex.scan(~r/\d+/, args)
      |> Enum.map(fn [str] -> String.to_integer(str) end)

    index = triangle(row + col - 1) - row + 1

    Stream.iterate(20_151_125, &next_number/1)
    |> Enum.at(index - 1)
  end

  def part2(_args) do
    # there is no part 2
  end
end
