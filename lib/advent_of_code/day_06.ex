defmodule AdventOfCode.Day06 do
  def manhattan_dist({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)

  def closest_point(x, y, points) do
    dists = Enum.map(points, &manhattan_dist(&1, {x, y}))

    {min_dist, point} =
      dists
      |> Enum.with_index()
      |> Enum.min_by(fn {dist, _index} -> dist end)

    if Enum.count(dists, &(&1 == min_dist)) > 1 do
      :draw
    else
      Enum.at(points, point)
    end
  end

  def parse_points(input) do
    input
    |> String.split([",", "\n", "\r", " "], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def get_bounds(points) do
    Enum.reduce(points, {nil, nil, 0, 0}, fn {x, y}, {min_x, min_y, max_x, max_y} ->
      {min(x, min_x), min(y, min_y), max(x, max_x), max(y, max_y)}
    end)
  end

  def distance_sum({x, y}, points), do: Enum.sum_by(points, &manhattan_dist(&1, {x, y}))

  def part1(input) do
    points = parse_points(input)

    {min_x, min_y, max_x, max_y} = get_bounds(points)

    grid = for x <- min_x..max_x, y <- min_y..max_y, do: {x, y}

    closest =
      grid
      |> Enum.reduce(%{}, fn {x, y}, acc ->
        case closest_point(x, y, points) do
          :draw -> acc
          n -> Map.update(acc, n, [{x, y}], &[{x, y} | &1])
        end
      end)

    closest
    |> Enum.reject(fn {{_x, _y}, list} ->
      Enum.any?(list, fn {x, y} -> x >= max_x or x <= min_x or y >= max_y or y <= min_y end)
    end)
    |> Enum.map(fn {_point, list} -> Enum.count(list) end)
    |> Enum.max()
  end

  def part2(input) do
    points = parse_points(input)

    {min_x, min_y, max_x, max_y} = get_bounds(points)

    for x <- min_x..max_x, y <- min_y..max_y do
      {x, y}
    end
    |> Enum.map(fn {x, y} -> distance_sum({x, y}, points) end)
    |> Enum.filter(&(&1 < 10000))
    |> Enum.count()
  end
end
