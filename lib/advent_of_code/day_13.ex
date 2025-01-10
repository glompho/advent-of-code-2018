defmodule AdventOfCode.Day13 do
  def parse(input) do
    input
    |> String.replace([".", "gain "], "")
    |> String.replace("lose ", "-")
    |> String.split([" happiness units by sitting next to ", " would ", "\n"], trim: true)
    |> Enum.chunk_every(3)
    |> Enum.reduce(%{}, fn [a, score, b], acc ->
      score = String.to_integer(score)

      acc
      |> Map.update(a, %{b => score}, fn map ->
        Map.update(map, b, score, fn current ->
          current + score
        end)
      end)
      |> Map.update(b, %{a => score}, fn map ->
        Map.update(map, a, score, fn current ->
          current + score
        end)
      end)
    end)
  end

  def perms([]), do: [[]]

  def perms(list) do
    for head <- list, tail <- perms(list -- [head]), do: [head | tail]
  end

  def cycles([head | rest]) do
    rest
    |> perms()
    |> Enum.map(fn perm -> [head | perm] end)
  end

  def find_best(map) do
    map
    |> Map.keys()
    |> cycles()
    |> Enum.map(fn perm ->
      score_perm(perm, map)
    end)
    |> Enum.max()
  end

  def score_perm(perm, map) do
    perm
    |> Enum.chunk_every(2, 1, [hd(perm)])
    |> Enum.map(fn [a, b] -> map[a][b] end)
    |> Enum.sum()
  end

  def part1(input) do
    input
    |> parse()
    |> find_best()
  end

  def part2(input) do
    map = parse(input)

    new_map =
      map
      |> Enum.map(fn {name, scores} ->
        {name, Map.put(scores, "Me", 0)}
      end)
      |> Map.new()
      |> Map.put(
        "Me",
        Map.keys(map)
        |> Enum.map(fn name -> {name, 0} end)
        |> Map.new()
      )

    new_map
    |> find_best()
  end
end
