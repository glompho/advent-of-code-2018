defmodule AdventOfCode.Day05 do
  def reduce(list) do
    new_list = one_step(list, []) |> Enum.reverse()

    if new_list == list do
      new_list
    else
      reduce(new_list)
    end
  end

  def one_step([], acc) do
    acc
  end

  def one_step([one_char], acc) do
    [one_char | acc]
  end

  def one_step([a, b | rest], acc) do
    if a != b and String.upcase(a) == String.upcase(b) do
      one_step(rest, acc)
    else
      one_step([b | rest], [a | acc])
    end
  end

  def part1(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> reduce()
    |> Enum.count()
  end

  def part2(input) do
    alphabet =
      ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)

    Enum.map(alphabet, fn letter ->
      Task.async(fn ->
        input
        |> String.replace(letter, "")
        |> String.replace(String.upcase(letter), "")
        |> part1()
      end)
    end)
    |> Enum.map(&Task.await(&1, 10000))
    |> Enum.min()
  end
end
