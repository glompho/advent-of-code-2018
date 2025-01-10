defmodule AdventOfCode.Day24 do
  def find_groups(packages, group_size) do
    find_groups(packages, {[], 0}, [], group_size)
  end

  def find_groups([], {set, size}, _unused, group_size) when size == group_size, do: set
  def find_groups([], _set_info, _unused, _group_size), do: []

  def find_groups([head | rem_packages], {set, size}, unused, group_size) do
    new_size = size + head

    cond do
      new_size == group_size ->
        [{[head | set], unused ++ rem_packages}]

      # |> IO.inspect(charlists: :as_list)

      new_size < group_size ->
        find_groups(rem_packages, {[head | set], new_size}, unused, group_size) ++
          find_groups(rem_packages, {set, size}, [head | unused], group_size)

      true ->
        find_groups(rem_packages, {set, size}, [head | unused], group_size)
    end
  end

  def score_group(group) do
    size = Enum.count(group)
    qe = Enum.product(group)

    {size, qe}
  end

  def group_valid?({group1, remainder}, group_size, n) do
    case n do
      3 -> group_can_three_split?({group1, remainder}, group_size)
      4 -> group_can_four_split?({group1, remainder}, group_size)
    end
  end

  def group_can_three_split?({group1, remainder}, group_size) do
    for {group2, group3} <- find_groups(remainder, group_size),
        Enum.sum(group3) == group_size do
      [group1, group2, group3]
      # |> IO.inspect(charlists: :as_list)
    end
    |> Enum.any?(fn _ -> true end)
  end

  def group_can_four_split?({group1, remainder}, group_size) do
    # not done!

    for {group2, remainder2} <- find_groups(remainder, group_size),
        {group3, group4} <- find_groups(remainder2, group_size),
        Enum.sum(group4) == group_size do
      [group1, group2, group3, group4]
      # |> IO.inspect(charlists: :as_list)
    end
    |> Enum.empty?()
    |> Kernel.!()
  end

  def find_best_brute(groups, group_size) do
    groups
    |> Enum.filter(&group_valid?(&1, group_size, 3))
    |> Enum.map(fn {group, _remainder} -> score_group(group) end)
    |> Enum.sort()
    |> hd()
    |> elem(1)
  end

  def score_better?(_current, nil) do
    true
  end

  def score_better?({size, qe}, {best_size, best_qe}) do
    cond do
      size < best_size -> true
      size == best_size and qe < best_qe -> true
      true -> false
    end
  end

  def find_best(queue, group_size, best, groups) do
    case :queue.out(queue) do
      {:empty, _} ->
        best

      {{:value, {group, remainder}}, queue} ->
        current = score_group(group)
        is_improvement = score_better?(current, best)

        cond do
          best != nil and not score_better?(current, best) ->
            # not the best solution
            find_best(queue, group_size, best, groups)

          group_valid?({group, remainder}, group_size, groups) and is_improvement ->
            # new best group found
            find_best(queue, group_size, current, groups)

          true ->
            # group was either invalid or not better
            find_best(queue, group_size, best, groups)
        end
    end
  end

  def parse(input, groups) do
    packages =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort(&>/2)

    group_size =
      packages
      |> Enum.sum()
      |> div(groups)

    {packages, group_size}
  end

  def part1(args) do
    {packages, group_size} = parse(args, 3)

    packages
    |> find_groups(group_size)
    |> :queue.from_list()
    |> find_best(group_size, nil, 3)
    |> elem(1)
  end

  def part2(args) do
    {packages, group_size} = parse(args, 4)

    packages
    |> find_groups(group_size)
    |> :queue.from_list()
    |> find_best(group_size, nil, 4)
    |> elem(1)
  end
end
