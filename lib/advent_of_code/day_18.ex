defmodule AdventOfCode.Day18 do
  @directions for row <- -1..1, col <- -1..1, {row, col} != {0, 0}, do: {row, col}

  def get_max(grid) do
    grid
    |> Map.keys()
    |> Enum.reduce({0, 0}, fn {row, col}, {max_row, max_col} ->
      {max(row, max_row), max(col, max_col)}
    end)
  end

  def draw_grid(grid) do
    {max_row, max_col} = get_max(grid)

    IO.puts("\n")

    for row <- 0..max_row do
      for col <- 0..max_col do
        case grid[{row, col}] do
          1 -> "#"
          0 -> "."
        end
      end
      |> IO.puts()
    end

    grid
  end

  def update_cell(grid, {row, col}) do
    neighbours =
      Enum.reduce(@directions, 0, fn {drow, dcol}, acc ->
        acc + Map.get(grid, {row + drow, col + dcol}, 0)
      end)

    cond do
      grid[{row, col}] == 1 and neighbours in [2, 3] -> 1
      grid[{row, col}] == 0 and neighbours == 3 -> 1
      true -> 0
    end
  end

  def update_grid(grid) do
    Enum.reduce(grid, %{}, fn {{row, col}, _state}, new_grid ->
      Map.put(new_grid, {row, col}, update_cell(grid, {row, col}))
    end)
  end

  def update_part2(grid) do
    {max_row, max_col} = get_max(grid)

    corners = [{max_row, max_col}, {max_row, 0}, {0, max_col}, {0, 0}]

    Enum.reduce(corners, update_grid(grid), fn {row, col}, grid ->
      Map.put(grid, {row, col}, 1)
    end)
  end

  def parse_grid(args) do
    char_key = %{"#" => 1, "." => 0}

    args
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, "", trim: true) |> Enum.with_index()))
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      Enum.reduce(line, acc, fn {char, col}, acc ->
        Map.put(acc, {row, col}, char_key[char])
      end)
    end)
  end

  def part1(args, steps \\ 100) do
    grid = parse_grid(args)

    Stream.iterate(grid, &update_grid/1)
    |> Enum.at(steps)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(args, steps \\ 100) do
    grid = parse_grid(args)

    Stream.iterate(grid, &update_part2/1)
    |> Enum.at(steps)
    # |> draw_grid()
    |> Map.values()
    |> Enum.sum()
  end
end
