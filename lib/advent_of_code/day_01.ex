defmodule AdventOfCode.Day01 do
  def part1(input) do
    Regex.scan(~r/-?\d+/, input)
    |> Enum.map(fn [str] -> String.to_integer(str) end)
    |> Enum.sum()
  end

  def part2(input) do
    Regex.scan(~r/-?\d+/, input)
    |> Enum.map(fn [str] -> String.to_integer(str) end)
    |> Stream.cycle()
    |> Stream.scan(&(&1 + &2))
    |> Enum.reduce_while(MapSet.new(), fn freq, seen ->
      if MapSet.member?(seen, freq) do
        {:halt, freq}
      else
        {:cont, MapSet.put(seen, freq)}
      end
    end)
  end
end
