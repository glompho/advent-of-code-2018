defmodule AdventOfCode.Day15 do
  def permutations([], _domain) do
    [[]]
  end

  def combinations(n, target) when n == 1, do: [[target]]

  def combinations(n, target) do
    for x <- 0..target,
        rest <- combinations(n - 1, target - x),
        do: [x | rest]
  end

  def find_final_amounts(args) do
    ingredients =
      args
      |> String.trim()
      |> then(&Regex.scan(~r/-{0,1}\d+/, &1))
      |> Enum.map(fn [str] -> String.to_integer(str) end)
      |> Enum.chunk_every(5)

    ingredients
    |> Enum.count()
    |> combinations(100)
    |> Enum.filter(fn list -> Enum.sum(list) == 100 end)
    |> Enum.map(fn quants ->
      Enum.zip_with(quants, ingredients, fn quant, ingredient ->
        Enum.map(ingredient, &(&1 * quant))
      end)
    end)
    |> Enum.map(fn totals ->
      Enum.zip_with(totals, &Enum.sum/1)
    end)
  end

  def find_best(quantities, count_calories?) do
    quantities
    |> Enum.map(fn final_amounts = [capacity, durability, flavor, texture, calories] ->
      cond do
        Enum.any?(final_amounts, &(&1 < 0)) -> 0
        count_calories? == true and calories != 500 -> 0
        true -> capacity * durability * flavor * texture
      end
    end)
    |> Enum.max()
  end

  def part1(args) do
    args
    |> find_final_amounts()
    |> find_best(_count_calories? = false)
  end

  def part2(args) do
    args
    |> find_final_amounts()
    |> find_best(_count_calories? = true)
  end
end
