defmodule AdventOfCode.Day02 do
  def part1(input) do
    {two_count, three_count} =
      input
      |> String.split(["\n", "\r"], trim: true)
      |> Enum.reduce({0, 0}, fn line, {two_count, three_count} ->
        counts =
          line
          |> String.graphemes()
          |> Enum.frequencies()
          |> Map.values()

        cond do
          3 in counts and 2 in counts ->
            {two_count + 1, three_count + 1}

          3 in counts ->
            {two_count, three_count + 1}

          2 in counts ->
            {two_count + 1, three_count}

          true ->
            {two_count, three_count}
        end
      end)

    two_count * three_count
  end

  def pairs(list) do
    Enum.flat_map(list, fn item1 ->
      Enum.map(list, fn item2 ->
        {item1, item2}
      end)
    end)
  end

  def str_i_map_set(string) do
    string
    |> String.graphemes()
    |> Enum.with_index()
    |> MapSet.new()
  end

  def chars_different(item1, item2) do
    MapSet.difference(str_i_map_set(item1), str_i_map_set(item2))
    |> MapSet.size()
  end

  def get_overlap({a, b}) do
    [a, b]
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.reduce([], fn
      {char, char}, acc ->
        [char | acc]

      _, acc ->
        acc
    end)
    |> Enum.reverse()
    |> Enum.join()
  end

  def part2(input) do
    list =
      input
      |> String.split(["\n", "\r"], trim: true)

    pairs(list)
    |> Enum.find(fn {a, b} -> chars_different(a, b) == 1 end)
    |> get_overlap()
  end
end
