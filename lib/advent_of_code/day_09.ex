defmodule AdventOfCode.Day09 do
  def perms([]), do: [[]]

  def perms(list) do
    for head <- list, tail <- perms(list -- [head]) do
      [head | tail]
    end
  end

  def get_dists(args) do
    dist_map =
      args
      |> String.split([" to ", " = ", "\n"])
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.reduce(%{}, fn [a, b, dist], acc ->
        dist = String.to_integer(dist)

        Map.update(acc, a, %{b => dist}, fn a_map ->
          Map.put(a_map, b, dist)
        end)
        |> Map.update(b, %{a => dist}, fn b_map ->
          Map.put(b_map, a, dist)
        end)
      end)

    dist_map
    |> Map.keys()
    |> perms()
    |> Enum.map(fn trip ->
      trip
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] ->
        dist_map[a][b]
      end)
      |> Enum.sum()
    end)
  end

  def part1(args) do
    get_dists(args) |> Enum.min()
  end

  def part2(args) do
    get_dists(args) |> Enum.max()
  end
end
