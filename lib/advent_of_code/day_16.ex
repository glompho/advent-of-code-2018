defmodule AdventOfCode.Day16 do
  @traces "children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1"
          |> String.split([": ", "\n"], trim: true)
          |> Enum.chunk_every(2)
          |> Enum.map(fn [name, amount] -> {name, amount} end)
          |> Map.new()

  def parse_aunts(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [num | pairs] =
        line
        |> String.split(["Sue ", ", ", ": ", "\n"], trim: true)

      map =
        pairs
        |> Enum.chunk_every(2)
        |> Enum.map(fn [a, b] -> {a, b} end)
        |> Map.new()

      {num, map}
    end)
  end

  def filter_aunts(aunts) do
    aunts
    |> Enum.filter(fn {_name, qualities_map} ->
      Enum.reduce_while(@traces, :could_be, fn {trace_name, trace_number}, status ->
        case qualities_map[trace_name] do
          nil -> {:cont, status}
          ^trace_number -> {:cont, status}
          _ -> {:halt, false}
        end
      end)
    end)
  end

  def filter_aunts_part2(aunts) do
    aunts
    |> Enum.filter(fn {_name, qualities_map} ->
      Enum.reduce_while(@traces, :could_be, fn {trace_name, trace_number}, status ->
        case qualities_map[trace_name] do
          nil ->
            {:cont, status}

          aunt_q_number ->
            case trace_name do
              tn when tn in ["cats", "trees"] and trace_number < aunt_q_number ->
                {:cont, status}

              tn when tn in ["pomeranians", "goldfish"] and trace_number > aunt_q_number ->
                {:cont, status}

              tn
              when tn not in ["pomeranians", "goldfish", "cats", "trees"] and
                     trace_number == aunt_q_number ->
                {:cont, status}

              _tn ->
                {:halt, false}
            end
        end
      end)
    end)
  end

  def part1(args) do
    [{nan_number, _}] =
      args
      |> parse_aunts()
      |> filter_aunts()

    String.to_integer(nan_number)
  end

  def part2(args) do
    [{nan_number, _}] =
      args
      |> parse_aunts()
      |> filter_aunts_part2()

    String.to_integer(nan_number)
  end
end
