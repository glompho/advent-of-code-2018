defmodule AdventOfCode.Day10 do
  def parse(input) do
    Regex.scan(~r/-?\d+/, input)
    |> Enum.map(fn [str] -> String.to_integer(str) end)
  end

  def get_dimensions(grid) do
    grid
    |> Map.keys()
    |> Enum.reduce({nil, nil, 0, 0}, fn {x, y}, {min_x, min_y, max_x, max_y} ->
      {min(x, min_x), min(y, min_y), max(x, max_x), max(y, max_y)}
    end)
  end

  def print_grid(particles, count) do
    grid =
      Enum.map(particles, fn [x, y, _, _] ->
        {{x, y}, "#"}
      end)
      |> Map.new()

    {min_x, min_y, max_x, max_y} = get_dimensions(grid)

    if abs(min_y - max_y) < 100 and abs(min_x - max_x) < 100 do
      IO.puts("---- \n")
      IO.gets("break")

      Enum.map(min_y..max_y, fn y ->
        Enum.map(min_x..max_x, fn x ->
          Map.get(grid, {x, y}, ".")
        end)
        |> Enum.join()
        |> IO.inspect()
      end)

      IO.puts(count)
    else
      nil
    end

    particles
  end

  def one_step(particles) do
    Enum.map(particles, fn [x, y, dx, dy] ->
      [x + dx, y + dy, dx, dy]
    end)
  end

  def loop(particles, count \\ 0) do
    print_grid(particles, count)

    particles
    |> one_step()
    |> loop(count + 1)
  end

  def part1(input) do
    input
    |> parse()
    |> Enum.chunk_every(4)
    |> loop()
  end

  def part2(_input) do
  end
end
