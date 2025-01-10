defmodule AdventOfCode.Day08 do
  def count(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn string ->
      full = length(String.to_charlist(string))
      regex = ~r/
                  \\\\         # Match a double backslash (escaped single backslash)
                  | \\\"       # Match an escaped double quote
                  | \\x[a-f0-9]{2}  # Match \x followed by exactly two hexadecimal digits
                  | [a-z]      # Match any lowercase letter
                  | \d         # Match any digit (0-9)
                /x

      parsed =
        Regex.scan(regex, string)
        |> length()

      expanded =
        string
        |> String.replace("\"", "!!")
        |> String.replace("\\", "!!")
        |> String.to_charlist()
        |> length()

      [full, parsed, expanded]
    end)
  end

  def part1(args) do
    count(args)
    |> Enum.map(fn [full, parsed, _expanded] -> full - parsed end)
    |> Enum.sum()
  end

  def part2(args) do
    count(args)
    |> Enum.map(fn [full, _parsed, expanded] -> 2 + expanded - full end)
    |> Enum.sum()
  end
end
