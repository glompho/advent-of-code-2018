defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  @tag :skip
  test "part1" do
    input = nil
    result = part1(input)

    assert result
  end

  test "part2" do
    input = "abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz"
    result = part2(input)

    assert result == "fgij"
  end
end
