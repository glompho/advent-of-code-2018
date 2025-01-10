defmodule AdventOfCode.Day19 do
  def parse(args) do
    [[target] | pairs] =
      args
      |> String.split(["\n", " => "], trim: true)
      |> Enum.chunk_every(2)
      |> Enum.reverse()

    {target, pairs}
  end

  def one_step(target, pairs) do
    pairs
    |> Enum.reduce(MapSet.new(), fn [a, b], acc ->
      Regex.scan(~r/#{a}/, target, return: :index)
      |> Enum.reduce(acc, fn [{pos, len}], acc_inner ->
        <<start::binary-size(pos), _::binary-size(len), rest::binary>> = target

        MapSet.put(acc_inner, start <> b <> rest)
      end)
    end)
  end

  def part1(args) do
    {target, pairs} = parse(args)

    one_step(target, pairs)
    |> MapSet.new()
    |> MapSet.size()
  end

  def find_steps(queue, target, pairs) do
    [{mol, steps} | tail] = queue

    if mol == target do
      steps
    else
      next =
        one_step(mol, pairs)
        |> Enum.map(fn mol -> {mol, steps + 1} end)

      new_queue =
        (next ++ tail)
        |> Enum.uniq()
        |> Enum.sort_by(fn {mol, _steps} -> String.length(mol) end)

      find_steps(new_queue, target, pairs)
    end
  end

  def part2(args) do
    {target, pairs} = parse(args)
    pairs = Enum.map(pairs, fn [a, b] -> [b, a] end)

    queue = [{target, 0}]
    find_steps(queue, "e", pairs)
  end

  # def part2(args) do
  #  {target, pairs} = parse(args)
  #
  #  Stream.iterate({MapSet.new([target]), %{}}, fn {current, cache} ->
  #    Enum.reduce(current, {_next = MapSet.new(), cache}, fn current_str, {state, cache} ->
  #      if cache[current_str] != nil do
  #        {[cache[current_str] | state], cache}
  #      else
  #        new_state =
  #          current_str
  #          |> one_step(pairs)
  #
  #        new_cache = Map.put(cache, current_str, new_state)
  #
  #        filtered_state =
  #          new_state
  #          |> Enum.filter(fn str ->
  #            String.length(str) < String.length(target) + 100
  #          end)
  #          |> MapSet.new()
  #
  #        {MapSet.union(filtered_state, state), new_cache}
  #      end
  #    end)
  #  end)
  #  |> Enum.find_index(fn {current, _cache} ->
  #    # IO.gets("break")
  #    # need to work out a way to follow threads as they go rather than doing the whole list
  #    IO.inspect(MapSet.size(current))
  #    MapSet.member?(current, "e")
  #  end)
  # end
end
