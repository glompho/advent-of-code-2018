defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "part1" do
    input = "18"
    result = part1(input)

    assert result == "33,45"
  end

  test "part1 _b" do
    input = "42"
    result = part1(input)

    assert result == "21,61"
  end

  # too slow to run every time
  @tag :skip
  test "part2" do
    input = "18"
    result = part2(input)

    assert result == "90,269,16"
  end

  @tag :skip

  test "part2 b" do
    input = "42"
    result = part2(input)

    assert result == "232,251,12"
  end
end
