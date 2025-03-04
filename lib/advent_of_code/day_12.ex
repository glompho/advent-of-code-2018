defmodule AdventOfCode.Day12 do
  def make_rules_map(rules) do
    Enum.map(rules, fn line ->
      [pre, [post]] = String.split(line, " => ") |> Enum.map(&String.graphemes/1)

      {pre, post}
    end)
    |> Map.new()
  end

  def steps(state, _rules_map, 0), do: state

  def steps(state, rules_map, n) do
    new_state =
      state
      |> one_step(rules_map)

    # |> print_state()

    steps(new_state, rules_map, n - 1)
  end

  def one_step(state, rules_map) do
    state
    |> then(fn s -> [".", ".", "." | s] ++ [".", ".", "."] end)
    |> then(fn s -> [".", "." | s] ++ ["."] end)
    |> Enum.chunk_every(5, 1)
    |> Enum.map(fn five -> Map.get(rules_map, five, ".") end)
  end

  def print_state(state) do
    state |> Enum.join() |> IO.inspect()

    state
  end

  def count_pots(state, offset) do
    state
    |> Enum.with_index()
    |> Enum.sum_by(fn {char, index} ->
      if char == "#" do
        index - offset
      else
        0
      end
    end)
  end

  def part1(input, steps \\ 20) do
    [start_state | rules] = String.split(input, ["\n", "\r"], trim: true)

    rules_map = make_rules_map(rules)

    offset = steps * 3

    start_state
    |> String.replace("initial state: ", "")
    |> String.graphemes()
    |> steps(rules_map, steps)
    |> count_pots(offset)
  end

  def part2(_input) do
  end
end
