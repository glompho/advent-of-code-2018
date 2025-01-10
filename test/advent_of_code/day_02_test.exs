defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = "2x3x4
1x1x10"
    result = part1(input)

    assert result == 101
  end

  test "part2" do
    input = "2x3x4
1x1x10"
    result = part2(input)

    assert result == 48
  end
end
