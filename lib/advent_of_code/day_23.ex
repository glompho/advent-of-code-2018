defmodule AdventOfCode.Day23 do
  def jump(state, offset) do
    Map.update!(state, "index", fn value -> value + String.to_integer(offset) end)
  end

  def increment_index(state) do
    Map.update!(state, "index", fn value -> value + 1 end)
  end

  def one_command(state, command) do
    case command do
      ["hlf", reg] ->
        Map.update!(state, reg, fn value -> div(value, 2) end)
        |> increment_index()

      ["tpl", reg] ->
        Map.update!(state, reg, fn value -> value * 3 end)
        |> increment_index()

      ["inc", reg] ->
        Map.update!(state, reg, fn value -> value + 1 end)
        |> increment_index()

      ["jmp", offset] ->
        Map.update!(state, "index", fn value -> value + String.to_integer(offset) end)

      ["jie", reg, offset] ->
        if rem(state[reg], 2) == 0 do
          jump(state, offset)
        else
          state
          |> increment_index()
        end

      ["jio", reg, offset] ->
        if state[reg] == 1 do
          jump(state, offset)
        else
          state
          |> increment_index()
        end
    end
  end

  def run_commands(commands, state = %{"index" => index}) do
    if index >= tuple_size(commands) do
      state
    else
      new_state =
        state
        |> one_command(elem(commands, index))

      run_commands(commands, new_state)
    end
  end

  def parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([", ", " "], trim: true)
    end)
    |> List.to_tuple()
  end

  def part1(args) do
    args
    |> parse()
    |> run_commands(%{"a" => 0, "b" => 0, "index" => 0})
    |> then(fn state -> state["b"] end)
  end

  def part2(args) do
    args
    |> parse()
    |> run_commands(%{"a" => 1, "b" => 0, "index" => 0})
    |> then(fn state -> state["b"] end)
  end
end
