defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1" do
    input = ~S({"a":{"b":4},"c":-1})
    result = part1(input)

    assert result == 3
  end

  test "part2" do
    assert part2("[1,2,13]") == 16
    assert part2(~S({"d":"red","e":[1,2,3,4],"f":5})) == 0

    assert part2(~S([1,"red",5])) == 6
  end
end
