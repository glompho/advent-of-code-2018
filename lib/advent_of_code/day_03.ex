defmodule AdventOfCode.Day03 do
  def parse(input) do
    Regex.scan(~r/\d+/, input)
    |> Enum.map(fn [str] -> String.to_integer(str) end)
    |> Enum.chunk_every(5)
  end

  def add_claim([_n, x, y, w, h], grid) do
    Enum.reduce(x..(x + w - 1), grid, fn x, grid ->
      Enum.reduce(y..(y + h - 1), grid, fn y, grid ->
        Map.update(grid, {x, y}, 1, &(&1 + 1))
      end)
    end)
  end

  def overlap?([_n, x, y, w, h], grid) do
    Enum.find_value(x..(x + w - 1), false, fn x ->
      Enum.find_value(y..(y + h - 1), false, fn y ->
        grid[{x, y}] != 1
      end)
    end)
  end

  def part1(input) do
    claims = parse(input)

    Enum.reduce(claims, %{}, &add_claim/2)
    |> Map.values()
    |> Enum.count(&(&1 > 1))
  end

  def part2(input) do
    claims = parse(input)

    grid = Enum.reduce(claims, %{}, &add_claim/2)

    Enum.find(claims, &(not overlap?(&1, grid)))
    |> hd()
  end
end
