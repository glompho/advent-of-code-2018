defmodule AdventOfCode.Day24Test do
  use ExUnit.Case

  import AdventOfCode.Day24
  @tag :skip
  test "part1" do
    input = "1
2
3
4
5
7
8
9
10
11"
    result = part1(input)

    assert result == 99
  end

  test "part2" do
    input = "1
2
3
4
5
7
8
9
10
11"
    result = part2(input)

    assert result == 44
  end
end
