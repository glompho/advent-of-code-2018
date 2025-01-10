defmodule AdventOfCode.Day11 do
  def increment_string(input) do
    input
    |> String.reverse()
    |> increment()
    |> String.reverse()
  end

  def increment(<<head::utf8, rest::binary>>) do
    case head do
      ?z -> <<?a>> <> increment(rest)
      # ?h -> <<?j>> <> rest
      # ?k -> <<?m>> <> rest
      # ?n -> <<?p>> <> rest
      _ -> <<head + 1>> <> rest
    end
  end

  def contains_straight?(input) do
    input
    |> String.to_charlist()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.any?(fn [a, b, c] -> b == a + 1 and c == b + 1 end)
  end

  def unambiguous?(input) do
    not String.contains?(input, ["i", "o", "l"])
  end

  def contains_two_pairs?(input) do
    pairs = Regex.scan(~r/([a-z])\1/, input)

    unique_pairs = pairs |> Enum.map(&hd/1)

    length(unique_pairs) >= 2
  end

  def check_rules(input) do
    contains_straight?(input) &&
      unambiguous?(input) &&
      contains_two_pairs?(input)
  end

  def one_step(input) do
    input
    |> Stream.iterate(&increment_string/1)
    |> Enum.find(&check_rules/1)
  end

  def part1(args) do
    args
    |> String.trim()
    |> one_step()
  end

  def part2(args) do
    args
    |> String.trim()
    |> one_step()
    |> increment_string()
    |> one_step()
  end
end
