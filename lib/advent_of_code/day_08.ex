defmodule AdventOfCode.Day08 do
  def structure([0, metadata_size | rest]) do
    {metadata, final_remainder} = Enum.split(rest, metadata_size)

    {[metadata], Enum.sum(metadata), final_remainder}
  end

  def structure([no_of_children, metadata_size | rest]) do
    {sub_metadata, children, remainder} =
      Enum.reduce(
        1..no_of_children,
        {[], [], rest},
        fn _child_index, {sub_metadata, children, remainder} ->
          {inner_metadata, score, remainder} = structure(remainder)
          {inner_metadata ++ sub_metadata, [score | children], remainder}
        end
      )

    {metadata, final_remainder} = Enum.split(remainder, metadata_size)

    score =
      cond do
        children == [] ->
          0

        true ->
          c = Enum.reverse(children)

          Enum.reduce(metadata, 0, fn index, acc ->
            acc + Enum.at(c, index - 1, 0)
          end)
      end

    {[metadata | sub_metadata], score, final_remainder}
  end

  def process(input) do
    input
    |> String.split([" ", "\n", "\r"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> structure()
  end

  def part1(input) do
    {metadata, _score, _remainder} = process(input)

    metadata |> List.flatten() |> Enum.sum()
  end

  def part2(input), do: process(input) |> elem(1)
end
