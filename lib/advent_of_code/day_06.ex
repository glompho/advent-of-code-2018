defmodule AdventOfCode.Day06 do
  def change_box(map, [x1, y1, x2, y2], func) do
    for x <- x1..x2, reduce: map do
      map ->
        for y <- y1..y2, reduce: map do
          map ->
            old = Map.get(map, [x, y], 0)
            Map.put(map, [x, y], func.(old))
        end
    end
  end

  def part1(args) do
    Regex.scan(~r/(turn on|turn off|toggle) (\d+),(\d+)[a-z ]*(\d+),(\d+)/, args)
    |> Enum.reduce(%{}, fn [_, command, x1, y1, x2, y2], acc ->
      points = [x1, y1, x2, y2] |> Enum.map(&String.to_integer/1)

      case command do
        "turn on" -> change_box(acc, points, fn _ -> 1 end)
        "turn off" -> change_box(acc, points, fn _ -> 0 end)
        "toggle" -> change_box(acc, points, fn x -> if x == 1, do: 0, else: 1 end)
      end
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(args) do
    Regex.scan(~r/(turn on|turn off|toggle) (\d+),(\d+)[a-z ]*(\d+),(\d+)/, args)
    |> Enum.reduce(%{}, fn [_, command, x1, y1, x2, y2], acc ->
      points = [x1, y1, x2, y2] |> Enum.map(&String.to_integer/1)

      case command do
        "turn on" -> change_box(acc, points, fn x -> x + 1 end)
        "turn off" -> change_box(acc, points, fn x -> max(x - 1, 0) end)
        "toggle" -> change_box(acc, points, fn x -> x + 2 end)
      end
    end)
    |> Map.values()
    |> Enum.sum()
  end
end
