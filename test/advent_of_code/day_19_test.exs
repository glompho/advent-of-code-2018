defmodule AdventOfCode.Day19Test do
  use ExUnit.Case

  import AdventOfCode.Day19

  test "part1" do
    input = "H => HO
H => OH
O => HH

HOHOHO"
    result = part1(input)

    assert result == 7
  end

  test "part2" do
    input = "e => H
e => O
H => HO
H => OH
O => HH

HOHOHO"
    result = part2(input)

    assert result == 6
  end
end
