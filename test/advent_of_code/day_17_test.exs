defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  test "part1" do
    input = "20
15
10
5
5"
    result = part1(input, 25)

    assert result == 4
  end

  test "part2" do
    input = "20
15
10
5
5"
    result = part2(input, 25)

    assert result == 3
  end
end
