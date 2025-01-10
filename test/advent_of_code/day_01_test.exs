defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = "()"
    result = part1(input)

    assert result == 0
  end

  test "part2" do
    input = "()())"
    result = part2(input)

    assert result == 5
  end
end
