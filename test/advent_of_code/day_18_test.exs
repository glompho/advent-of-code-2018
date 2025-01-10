defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  import AdventOfCode.Day18

  test "part1" do
    input = ".#.#.#
...##.
#....#
..#...
#.#..#
####.."
    result = part1(input, 4)

    assert result == 4
  end

  test "part2" do
    input = "##.#.#
...##.
#....#
..#...
#.#..#
####.#"
    result = part2(input, 5)

    assert result == 17
  end
end
