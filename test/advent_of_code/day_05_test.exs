defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "part1" do
    input = "ugknbfddgicrmopn"
    result = part1(input)
    assert result == 1
  end

  test "part1_2" do
    input = "aaa"
    result = part1(input)
    assert result == 1
  end

  test "part1_no_double" do
    input = "jchzalrnumimnmhp"
    result = part1(input)
    assert result == 0
  end

  test "part1_xy" do
    input = "haegwjzuvuyypxyu"
    result = part1(input)
    assert result == 0
  end

  test "part1_one_vowel" do
    input = "dvszwmarrgswjxmb"
    result = part1(input)
    assert result == 0
  end

  test "part2_nice" do
    input = "qjhvhtzxzqqjkmpb"
    result = part2(input)

    assert result == 1
  end

  test "part2_nice2" do
    input = "xxyxx"
    result = part2(input)

    assert result == 1
  end

  test "part2_no_char_repeat_with_single" do
    input = "uurcxstgmygtbstg"
    result = part2(input)

    assert result == 0
  end

  test "part2_no_pair_twice" do
    input = "ieodomkazucvgmuy"
    result = part2(input)

    assert result == 0
  end
end
