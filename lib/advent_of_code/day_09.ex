defmodule DoubleLinkedList do
  defstruct index: 0, count: 0, nodes: %{}

  def insert(%DoubleLinkedList{nodes: nodes}, value) when map_size(nodes) == 0 do
    %DoubleLinkedList{count: 0, nodes: %{0 => %{value: value, prev: 0, next: 0}}}
  end

  def insert(dll = %DoubleLinkedList{index: index, count: count, nodes: nodes}, value) do
    new_index = count + 1
    current_node = access(dll)

    new_node = %{value: value, prev: index, next: current_node.next}

    new_nodes =
      nodes
      |> Map.put(new_index, new_node)
      |> Map.update!(index, &Map.put(&1, :next, new_index))
      |> Map.update!(current_node.next, &Map.put(&1, :prev, new_index))

    %DoubleLinkedList{index: new_index, count: new_index, nodes: new_nodes}
  end

  def access(%DoubleLinkedList{index: index, nodes: nodes}) do
    Map.get(nodes, index)
  end

  def travel(dll = %DoubleLinkedList{index: index, nodes: nodes}, direction) do
    new_index =
      nodes
      |> Map.get(index)
      |> Map.get(direction)

    %DoubleLinkedList{dll | index: new_index, nodes: nodes}
  end

  def travel(dll, _direction, 0), do: dll

  def travel(dll, direction, n) do
    dll
    |> travel(direction)
    |> travel(direction, n - 1)
  end

  def next_node(dll, n \\ 1), do: travel(dll, :next, n)

  def prev_node(dll, n \\ 1), do: travel(dll, :prev, n)

  def delete_current(dll = %DoubleLinkedList{count: count, nodes: nodes}) do
    current = access(dll)
    next_node = dll |> next_node() |> access()

    new_nodes =
      nodes
      |> Map.update!(current.next, &Map.put(&1, :prev, current.prev))
      |> Map.update!(current.prev, &Map.put(&1, :next, current.next))
      |> Map.delete(next_node.prev)

    %DoubleLinkedList{index: current.next, count: count - 1, nodes: new_nodes}
  end
end

defmodule AdventOfCode.Day09 do
  # to do
  # update to use dll.
  def pretty_print(player_id, game_state, index) do
    pretty_state =
      game_state
      |> Enum.with_index()
      |> Enum.map(fn {score, list_index} ->
        if list_index == index do
          "(#{score})"
        else
          score
        end
      end)
      |> Enum.join(" ")

    "[#{player_id}] #{pretty_state}" |> IO.inspect()
  end

  def simulate(players, final_score) do
    final_score |> IO.inspect()

    1..final_score
    |> Enum.reduce({%{}, [0], 0}, fn score, {player_scores, game_state, index} ->
      player_id = rem(score - 1, players) + 1
      marbles_in_play = length(game_state)
      IO.inspect(marbles_in_play)

      cond do
        rem(score, 23) == 0 ->
          new_index = Integer.mod(index - 7, marbles_in_play)
          seven_ccw = Enum.at(game_state, new_index)

          new_game_state = List.delete_at(game_state, new_index)

          new_player_scores =
            player_scores
            |> Map.update(player_id, score + seven_ccw, &(&1 + score + seven_ccw))

          # pretty_print(player_id, new_game_state, new_index)
          # IO.gets("break")
          {new_player_scores, new_game_state, new_index}

        true ->
          new_index = Integer.mod(index + 1, marbles_in_play)
          new_game_state = List.insert_at(game_state, new_index + 1, score)
          # pretty_print(player_id, new_game_state, new_index)
          {player_scores, new_game_state, new_index + 1}
      end
    end)
    |> elem(0)
    |> Map.values()
    |> Enum.max()
  end

  def parse(input) do
    Regex.scan(~r/\d+/, input)
    |> Enum.map(fn [str] -> String.to_integer(str) end)
  end

  def part1(input) do
    [players, final_score] = parse(input)

    simulate(players, final_score)
  end

  def part2(input) do
    [players, final_score] = parse(input)

    simulate(players, final_score * 100)
  end
end
