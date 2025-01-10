defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  import AdventOfCode.Day14

  test "part1" do
    input = "
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
"
    result = part1(input, 1000)

    assert result == 1120
  end

  test "part2" do
    input = "
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
"

    # assert part2(input, 1) == 1
    # assert part2(input, 140) == 139

    result = part2(input, 1000)

    assert result == 689
  end
end
