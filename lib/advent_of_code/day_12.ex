defmodule AdventOfCode.Day12 do
  def part1(args) do
    Regex.scan(~r/-?[0-9]\d*/, args)
    |> Enum.map(&hd/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def remove(str) do
    Regex.replace(~r/{[^{}]*:"red"[^{}]*}/U, str, "")
  end

  def parse(string) do
    parse(string, [])
  end

  def parse(string, parsed) do
    case string do
      "{" <> rest ->
        {sub_parsed, after_sub} = parse(rest)
        {after_parsed, after_rest} = parse(after_sub)

        {[Enum.reverse(parsed) ++ after_parsed, sub_parsed], after_rest}

      "}" <> rest ->
        {Enum.reverse(parsed), rest}

      <<char::utf8, rest::binary>> ->
        parse(rest, [char | parsed])

      "" ->
        {Enum.reverse(parsed), []}
    end
  end

  def evaluate([]) do
    0
  end

  def evaluate([[] | rest]) do
    evaluate(rest)
  end

  def evaluate(input) do
    cond do
      is_integer(input) ->
        input

      List.ascii_printable?(input) ->
        count_input(input)

      true ->
        [head | rest] = input
        evaluate(head) + evaluate(rest)
    end
  end

  def count_input(input) do
    string = List.to_string(input)

    if Regex.match?(~r/:"red"/, string) do
      0
    else
      part1(string)
    end
  end

  def sum_parsed(parsed) when is_map(parsed) do
    if "red" in Map.values(parsed) do
      0
    else
      sum_parsed(Map.values(parsed))
    end
  end

  def sum_parsed(parsed) when is_list(parsed) do
    Enum.sum_by(parsed, &sum_parsed/1)
  end

  def sum_parsed(n) when is_integer(n), do: n
  def sum_parsed(_parsed), do: 0

  def part2(args) do
    args
    |> parse()
    # |> IO.inspect()
    |> elem(0)
    |> evaluate()

    # gave up and used a prebuilt parser
    args
    |> Jason.decode()
    |> elem(1)
    |> sum_parsed()
  end
end
