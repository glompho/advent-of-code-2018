defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "check straight" do
    assert contains_straight?("hijklmmn") == true
    assert contains_straight?("abbceffgn") == false
  end

  test "contains i o or l" do
    assert unambiguous?("abciol") == false
    assert unambiguous?("hello") == false
    assert unambiguous?("hi") == false
    assert unambiguous?("no way") == false
    assert unambiguous?("abc") == true
  end

  test "contains two different, non-overlapping pairs of letters, like aa, bb, or zz." do
    assert contains_two_pairs?("abbcegjk") == false
    assert contains_two_pairs?("aaa") == false
    assert contains_two_pairs?("aajkaa") == true
    assert contains_two_pairs?("aaaa") == true
    assert contains_two_pairs?("abcdffaa") == true
  end

  test "part1" do
    input = "abcdefgh"
    result = part1(input)

    assert result == "abcdffaa"
  end

  @tag :skip
  test "part1 2" do
    input = "ghijklmn"
    result = part1(input)

    assert result == "ghjaabcc"
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
