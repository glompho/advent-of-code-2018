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

    # Inspected the difference over time to work out the partern which was very regular.

    # old_count = state |> count_pots((1000 - n) * 3)
    # new_count = new_state |> count_pots((1000 - n + 1) * 3)
    # |> IO.inspect(label: n)
    # IO.puts("#{1000 - n}, diff= #{new_count - old_count}")

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

  def part2(input, steps \\ 50_000_000_000) do
    # numbers hard coded after inspection

    initial_number = part1(input, 191)
    rest = 34 * (steps - 191)
    initial_number + rest
  end
end
