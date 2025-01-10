defmodule AdventOfCode.Day07 do
  def try_var(var, map) do
    case Integer.parse(var) do
      :error ->
        Map.get(map, var)

      {number, ""} ->
        number
    end
  end

  def resolve([], map) do
    map
  end

  def resolve([instruction | rest], map) do
    [input, out] =
      String.split(instruction, " -> ", trim: true)

    case String.split(input, " ", trim: true) do
      [var] ->
        input_var = try_var(var, map)

        if input_var != nil do
          resolve(rest, Map.put(map, out, input_var))
        else
          resolve(rest ++ [instruction], map)
        end

      ["NOT", var] ->
        input_var = try_var(var, map)

        if input_var != nil do
          resolve(rest, Map.put(map, out, Integer.mod(Bitwise.bnot(input_var), 65536)))
        else
          resolve(rest ++ [instruction], map)
        end

      [a, op, b] ->
        a = try_var(a, map)
        b = try_var(b, map)

        func =
          case op do
            "OR" -> &Bitwise.bor/2
            "AND" -> &Bitwise.band/2
            "LSHIFT" -> &Bitwise.<<</2
            "RSHIFT" -> &Bitwise.>>>/2
          end

        if a != nil and b != nil do
          resolve(rest, Map.put(map, out, Integer.mod(func.(a, b), 65536)))
        else
          # If we don't know the vars yet move it to the back of the queue
          resolve(rest ++ [instruction], map)
        end
    end
  end

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> resolve(%{})
    |> Map.get("a")
  end

  def part2(args) do
    # Assume b is directly defined for the question to make sense
    # Replace it with answer from part 1
    String.replace(args, ~r/\d+ -> b\n/, "#{part1(args)} -> b\n")
    |> part1()
  end
end
