defmodule AdventOfCode.Day25Test do
  use ExUnit.Case

  import AdventOfCode.Day25

  test "part1" do
    input =
      "To continue, please consult the code grid in the manual.  Enter the code at row 1, column 6."

    result = part1(input)

    assert result == 33_511_524
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
