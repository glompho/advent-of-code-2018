defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Day08

  test "part1" do
    input = ~S(""
"abc"
"aaa\"aaa"
"\x27")
    result = part1(input)

    assert result == 12
  end

  test "part1_making_more" do
    input = ~S("sjdivfriyaaqa\xd2v\"k\"mpcu\"yyu\"en"
"vcqc"
"zbcwgmbpijcxu\"yins\"sfxn"
"yumngprx"
"bbdj"
"czbggabkzo\"wsnw\"voklp\"s"
"acwt"
"aqttwnsohbzian\"evtllfxwkog\"cunzw")

    result = part1(input)

    assert result == 30
  end

  test "part2" do
    input = ~S(""
"abc"
"aaa\"aaa"
"\x27")
    result = part2(input)

    assert result == 19
  end
end
