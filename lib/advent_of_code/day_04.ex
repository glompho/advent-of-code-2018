defmodule AdventOfCode.Day04 do
  def mine(args, num, leading_zeros) do
    hash = :crypto.hash(:md5, args <> Integer.to_string(num)) |> Base.encode16()
    goal = String.duplicate("0", leading_zeros)

    if String.starts_with?(hash, goal) do
      num
    else
      mine(args, num + 1, leading_zeros)
    end
  end

  def part1(args) do
    mine(String.trim(args), 1, 5)
  end

  def part2(args) do
    mine(String.trim(args), 1, 6)
  end
end
