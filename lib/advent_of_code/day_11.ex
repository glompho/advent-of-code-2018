defmodule AdventOfCode.Day11 do
  def get_hundreds(n) when n > 100 or n < -100 do
    n |> div(100) |> rem(10)
  end

  def get_dimensions(grid) do
    grid
    |> Map.keys()
    |> Enum.reduce({nil, nil, 0, 0}, fn {x, y}, {min_x, min_y, max_x, max_y} ->
      {min(x, min_x), min(y, min_y), max(x, max_x), max(y, max_y)}
    end)
  end

  def print_grid(grid) do
    {min_x, min_y, max_x, max_y} = get_dimensions(grid)

    Enum.map(min_y..max_y, fn y ->
      Enum.map(min_x..max_x, fn x ->
        " #{Map.get(grid, {x, y}, ".")} "
      end)
      |> Enum.join()
      |> IO.inspect()

      grid
    end)
  end

  def get_power_level(x, y, grid_id) do
    rack_id = x + 10

    get_hundreds((rack_id * y + grid_id) * rack_id) - 5
  end

  def find_square_score(sx, sy, size, grid_id) do
    ex = min(300, sx + size - 1)
    ey = min(300, sy + size - 1)

    for x <- sx..ex, y <- sy..ey, reduce: 0 do
      acc -> acc + get_power_level(x, y, grid_id)
    end
  end

  def generate_grid(grid_id) do
    for x <- 1..300, y <- 1..300 do
      square_score = find_square_score(x, y, 3, grid_id)

      {{x, y}, square_score}
    end
  end

  # https://en.wikipedia.org/wiki/Summed-area_table
  def generate_summing_table(grid_id) do
    for x <- 1..300, y <- 1..300, reduce: %{} do
      grid ->
        a = Map.get(grid, {x, y - 1}, 0)
        b = Map.get(grid, {x - 1, y}, 0)
        c = Map.get(grid, {x - 1, y - 1}, 0)
        d = get_power_level(x, y, grid_id)

        total = a + b - c + d

        Map.put(grid, {x, y}, total)
    end
  end

  def find_score_from_summing_grid(x, y, size, summing_table) do
    a = summing_table[{x - 1, y - 1}] || 0
    b = summing_table[{x - 1 + size, y - 1}] || 0
    c = summing_table[{x - 1, y - 1 + size}] || 0
    d = summing_table[{x - 1 + size, y - 1 + size}] || 0

    a + d - b - c
  end

  def find_best_square_score(sx, sy, summing_table) do
    # IO.inspect({sx, sy})
    max_size = min(299 - sx, 299 - sy)

    if max_size < 3 do
      {0, 0}
    else
      for size <- 2..max_size, reduce: {_size = 0, _sum = 0} do
        {best_size, best_sum} ->
          sum = find_score_from_summing_grid(sx, sy, size, summing_table)

          if sum > best_sum do
            {size, sum}
          else
            {best_size, best_sum}
          end
      end
    end
  end

  def generate_best_square_grid(summing_table) do
    for x <- 1..300, y <- 1..300 do
      square_score = find_best_square_score(x, y, summing_table)

      {{x, y}, square_score}
    end
  end

  def part1(input) do
    {x, y} =
      input
      |> String.trim()
      |> String.to_integer()
      |> generate_grid()
      |> Enum.max_by(&elem(&1, 1))
      |> elem(0)

    "#{x},#{y}"
  end

  def part2(input) do
    {{x, y}, {size, _score}} =
      input
      |> String.trim()
      |> String.to_integer()
      |> generate_summing_table()
      |> generate_best_square_grid()
      |> Enum.max_by(fn {{_x, _y}, {_size, score}} -> score end)

    "#{x},#{y},#{size}"
  end
end
