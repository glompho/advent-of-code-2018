defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09
  @tag :skip
  test "part1" do
    input = "9 players; last marble is worth 25 points"
    result = part1(input)

    assert result == 32
  end

  @tag :skip
  test "part1 second test" do
    input = "10 players; last marble is worth 1618 points"
    result = part1(input)

    assert result == 8317
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
