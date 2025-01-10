defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04
  @tag :skip
  test "part1" do
    input = "abcdef"
    result = part1(input)

    assert result == 609_043
  end

  @tag :skip
  test "part1_2" do
    input = "pqrstuv"
    result = part1(input)

    assert result == 1_048_970
  end

  @tag :skip
  test "part1_testing_fetch" do
    # This uncovered that I needed to trim a \n
    input = "yzbqklnj"
    result = part1(input)
    assert result == 282_749
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
