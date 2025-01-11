defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = "R5, L5, R5, R3"
    result = part1(input)

    assert result == 12
  end

  test "part2" do
    input = "R8, R4, R4, R8"
    result = part2(input)

    assert result == 4
  end
end
