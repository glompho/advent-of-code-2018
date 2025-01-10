defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10
  @tag :skip
  test "part1" do
    input = "211"
    result = part1(input, 1)

    assert result == 4
  end

  test "part1 second example" do
    input = "1"
    result = part1(input, 5)

    assert result == 6
  end

  test "part2" do
    input = "1"
    result = part2(input, 10)

    assert result == 26
  end
end
