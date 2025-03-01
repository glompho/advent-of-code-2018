defmodule DoubleLinkedList do
  defstruct index: 0, next_index: 0, nodes: %{}

  def insert(%DoubleLinkedList{nodes: nodes}, value) when map_size(nodes) == 0 do
    %DoubleLinkedList{next_index: 1, nodes: %{0 => %{value: value, prev: 0, next: 0}}}
  end

  def insert(dll = %DoubleLinkedList{index: index, next_index: next_index, nodes: nodes}, value) do
    new_index = next_index
    current_node = access(dll)

    new_node = %{value: value, prev: index, next: current_node.next}

    new_nodes =
      nodes
      |> Map.put(new_index, new_node)
      |> Map.update!(index, &Map.put(&1, :next, new_index))
      |> Map.update!(current_node.next, &Map.put(&1, :prev, new_index))

    %DoubleLinkedList{index: new_index, next_index: next_index + 1, nodes: new_nodes}
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

  def delete_current(dll = %DoubleLinkedList{next_index: next_index, nodes: nodes}) do
    current = access(dll)

    new_nodes =
      nodes
      |> Map.update!(current.next, &Map.put(&1, :prev, current.prev))
      |> Map.update!(current.prev, &Map.put(&1, :next, current.next))
      |> Map.delete(dll.index)

    %DoubleLinkedList{index: current.next, next_index: next_index, nodes: new_nodes}
  end

  def to_list(%DoubleLinkedList{nodes: nodes}) when map_size(nodes) == 0 do
    []
  end

  def to_list(dll) do
    min_index = dll.nodes |> Map.keys() |> Enum.min()

    dll
    |> Map.put(:index, min_index)
    |> to_list([], min_index)
    |> Enum.reverse()
  end

  def to_list(%DoubleLinkedList{index: start}, acc, start) when acc != [] do
    acc
  end

  def to_list(%DoubleLinkedList{nodes: nodes}, acc, _start)
      when length(acc) >= map_size(nodes) do
    acc
  end

  def to_list(dll, acc, start) do
    # IO.inspect({map_size(dll.nodes), length(acc), acc})
    # IO.gets("break")

    # IO.inspect(dll)
    current = access(dll)
    # IO.inspect(current)

    # if current.value in acc do
    #  IO.inspect("CYCLE PROBLEM")
    # end

    next_state = dll |> next_node()
    to_list(next_state, [current.value | acc], start)
  end
end

defmodule AdventOfCode.Day09 do
  import DoubleLinkedList
  # to do
  # update to use dll.
  def pretty_print(player_id, game_state, index) do
    pretty_state =
      game_state
      |> Enum.with_index()
      |> Enum.map(fn {score, list_index} ->
        if list_index == index do
          "#{score}"
        else
          score
        end
      end)
      |> Enum.join(" ")

    "[#{player_id}] #{pretty_state}" |> IO.inspect()
  end

  def simulate(players, final_score) do
    1..final_score
    |> Enum.reduce({%{}, [0], 0}, fn score, {player_scores, game_state, index} ->
      player_id = rem(score - 1, players) + 1
      marbles_in_play = length(game_state)

      cond do
        rem(score, 23) == 0 ->
          new_index = Integer.mod(index - 7, marbles_in_play)
          seven_ccw = Enum.at(game_state, new_index)
          IO.inspect({"score", score, seven_ccw})
          new_game_state = List.delete_at(game_state, new_index)

          new_player_scores =
            player_scores
            |> Map.update(player_id, score + seven_ccw, &(&1 + score + seven_ccw))

          pretty_print(player_id, game_state, new_index)
          pretty_print(player_id, new_game_state, new_index)
          # IO.gets("break")
          {new_player_scores, new_game_state, new_index}

        true ->
          new_index = Integer.mod(index + 1, marbles_in_play)
          new_game_state = List.insert_at(game_state, new_index + 1, score)
          # IO.inspect({score, Enum.at(game_state, new_index)})
          pretty_print(player_id, new_game_state, new_index)
          {player_scores, new_game_state, new_index + 1}
      end
    end)
    |> elem(0)
    |> Map.values()
    |> Enum.max()
  end

  def simulate2(players, final_score) do
    start_state = %DoubleLinkedList{} |> insert(0)

    1..final_score
    |> Enum.reduce({%{}, start_state}, fn score, {player_scores, game_state} ->
      player_id = rem(score - 1, players) + 1

      cond do
        rem(score, 23) == 0 ->
          # IO.inspect(game_state)
          seven_ccw = prev_node(game_state, 7)

          seven_ccw_value = seven_ccw |> access() |> Map.get(:value)

          new_game_state = delete_current(seven_ccw)
          # IO.inspect({"score (method 2)", score, seven_ccw_value})
          # lst1 = to_list(game_state)
          # lst2 = to_list(new_game_state)
          # pretty_print(player_id, lst1, game_state.index)
          # pretty_print(player_id, lst2, new_game_state.index)

          new_player_scores =
            player_scores
            |> Map.update(player_id, score + seven_ccw_value, &(&1 + score + seven_ccw_value))

          # pretty_print(player_id, new_game_state, new_index)
          # IO.gets("break")
          {new_player_scores, new_game_state}

        true ->
          # IO.inspect(access(game_state))
          # IO.inspect(access(next_node(game_state)))
          # IO.inspect(game_state.nodes)
          new_game_state = game_state |> next_node() |> insert(score)
          # lst = to_list(new_game_state)
          # IO.inspect({score, game_state |> access() |> Map.get(:value)})

          # pretty_print(player_id, lst, new_game_state.index)
          {player_scores, new_game_state}
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

    # simulate(players, final_score)

    simulate2(players, final_score)
  end

  def part2(input) do
    [players, final_score] = parse(input)

    simulate2(players, final_score * 100)
  end
end
