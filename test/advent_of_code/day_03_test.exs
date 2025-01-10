defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "part1" do
    input = ">"
    result = part1(input)

    assert result == 2
  end

  test "part1_2" do
    input = "^>v<"
    result = part1(input)
    assert result == 4
  end

  test "part1_3" do
    input = "^v^v^v^v^v"
    result = part1(input)
    assert result == 2
  end

  test "part2" do
    input = "^v"
    result = part2(input)
    assert result == 3
  end

  test "part2_2" do
    input = "^>v<"
    result = part2(input)
    assert result == 3
  end

  test "part2_3" do
    input = "^v^v^v^v^v"
    result = part2(input)
    assert result == 11
  end
end
