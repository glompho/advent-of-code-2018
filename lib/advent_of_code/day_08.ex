defmodule AdventOfCode.Day08 do
  def structure([]), do: {[], []}

  def structure([0, metadata_size | rest]) do
    {metadata, final_remainder} = Enum.split(rest, metadata_size)

    {[metadata], final_remainder}
  end

  def structure([no_of_children, metadata_size | rest]) do
    # IO.inspect([no_of_children, metadata_size | rest])

    {children, remainder} =
      Enum.reduce(1..no_of_children, {[], rest}, fn _child_index, {children, remainder} ->
        {sub_children, remainder} = structure(remainder)
        {children ++ sub_children, remainder}
      end)

    {metadata, final_remainder} = Enum.split(remainder, metadata_size)
    # dbg()
    {[metadata | children], final_remainder}
  end

  def part1(input) do
    {metadata, _remainder} =
      input
      |> String.split([" ", "\n", "\r"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> structure()

    # |> IO.inspect(charlists: :as_lists)

    metadata
    |> List.flatten()
    |> Enum.sum()
  end

  def part2(_input) do
  end
end
