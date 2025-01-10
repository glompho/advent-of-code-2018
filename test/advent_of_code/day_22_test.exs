defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  test "part1 example 1" do
    player = {10, 250}
    boss = {13, 8}
    initial_state = {player, boss, %{}, 0}
    result = simulate_game(initial_state)

    assert result == {:win, 226}
  end

  test "part1" do
    player = {10, 250}
    boss = {14, 8}
    initial_state = {player, boss, %{}, 0}
    result = simulate_game(initial_state)

    assert result == {:win, 641}
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
