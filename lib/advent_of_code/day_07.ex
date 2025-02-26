defmodule AdventOfCode.Day07 do
  def parse(input) do
    input
    |> String.replace(~r/Step|[^A-Z ^\s]/, "")
    |> String.split([" ", "\n", "\r"], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.reduce({%{}, %{}, MapSet.new()}, fn [pre, post], {enables, depends, tasks} ->
      {_enables = Map.update(enables, pre, MapSet.new([post]), &MapSet.put(&1, post)),
       _depends = Map.update(depends, post, MapSet.new([pre]), &MapSet.put(&1, pre)),
       _tasks = tasks |> MapSet.put(pre) |> MapSet.put(post)}
    end)
  end

  def get_first(enables, depends) do
    e = enables |> Map.keys() |> MapSet.new()
    d = depends |> Map.keys() |> MapSet.new()

    MapSet.difference(e, d)
    |> MapSet.to_list()
  end

  def one_step(enables, depends, next, so_far) do
    next_node = next |> hd()

    to_update = Map.get(enables, next_node)

    {new_depends, new_next} =
      Enum.reduce(depends, {%{}, next}, fn {node, current_deps}, {new_depends, new_next} ->
        if node in to_update do
          new_deps = MapSet.delete(current_deps, next_node)

          if new_deps == MapSet.new() do
            {new_depends, [node | new_next]}
          else
            {Map.put(new_depends, node, new_deps), new_next}
          end
        else
          {Map.put(new_depends, node, current_deps), new_next}
        end
      end)

    new_enables = Map.drop(enables, [next_node])

    next_final =
      new_next
      |> Enum.filter(&(&1 != next_node))
      |> Enum.sort()

    {new_enables, new_depends, next_final, [next_node | so_far]}
  end

  def resolve(enables, _depends, [final], sequence)
      when map_size(enables) == 0 and sequence != [] do
    Enum.reverse([final | sequence])
    |> Enum.join()
  end

  def resolve(enables, depends, next, sequence) do
    {enables, depends, next, sequence} = one_step(enables, depends, next, sequence)

    resolve(enables, depends, next, sequence)
  end

  def part1(input) do
    {enables, depends, _tasks} = parse(input)

    first = get_first(enables, depends)

    resolve(enables, depends, first, [])
  end

  def part2(_input) do
  end
end
