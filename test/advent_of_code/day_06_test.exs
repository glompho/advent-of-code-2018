defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = "turn on 0,0 through 9,9
    toggle 0,0 through 0,9
    turn off 4,4 through 5,5"
    result = part1(input)

    assert result == 10 * 10 - 10 - 4
  end

  @tag :skip
  test "part2" do
    input = "turn on 0,0 through 9,9
    toggle 0,0 through 0,9
    turn off 4,4 through 5,5"

    result = part2(input)

    assert result == 10 * 10 - 10 + 8
  end
end
