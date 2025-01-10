defmodule AdventOfCode.Day21Test do
  use ExUnit.Case

  import AdventOfCode.Day21

  test "fight" do
    assert fight({8, 5, 5}, {12, 7, 2}, :player_turn) == :win
  end

  test "parse boss" do
    input = "Hit Points: 12
Damage: 7
Armor: 2"
    assert parse_boss(input) == {12, 7, 2}
  end

  test "parse and fight" do
    input = "Hit Points: 12
Damage: 7
Armor: 2"
    boss = parse_boss(input)
    result = fight({8, 5, 5}, boss)

    assert result == :win
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
