defmodule AdventOfCode.Day04 do
  def parse(input) do
    input
    |> String.replace(" begins shift", "")
    |> String.split(["[", "] ", "\n", "\r"], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [dt, line] ->
      {NaiveDateTime.from_iso8601!(dt <> ":00"), line}
    end)
    |> Enum.sort_by(&elem(&1, 0), NaiveDateTime)
  end

  def parse_events(input) do
    input
    |> parse()
    |> Enum.reduce({_map = %{}, _guard = nil}, fn {dt, line}, {map, guard} ->
      case line do
        "Guard #" <> guard_num ->
          new_map = Map.update(map, guard_num, [{:start, dt}], &[{:start, dt} | &1])
          {new_map, guard_num}

        "falls asleep" ->
          new_map = Map.update(map, guard, [{:asleep, dt}], &[{:asleep, dt} | &1])
          {new_map, guard}

        "wakes up" ->
          new_map = Map.update(map, guard, [{:awake, dt}], &[{:awake, dt} | &1])
          {new_map, guard}
      end
    end)
    |> elem(0)
  end

  def mins_asleep(guard_events) do
    guard_events
    |> Enum.reverse()
    |> Enum.reduce({_mins = 0, _state = nil, _last_dt = nil}, fn {new_state, new_dt},
                                                                 {mins, state, last_dt} ->
      new_mins =
        case {state, new_state} do
          {:asleep, :awake} -> mins + NaiveDateTime.diff(new_dt, last_dt, :minute)
          _ -> mins
        end

      {new_mins, new_state, new_dt}
    end)
    |> elem(0)
  end

  def most_sleepy_min(guard_events) do
    guard_events
    |> Enum.reverse()
    |> Enum.reduce({_mins = %{}, _state = nil, _last_dt = nil}, fn {new_state, new_dt},
                                                                   {min_map, state, last_dt} ->
      new_min_map =
        case {state, new_state} do
          {:asleep, :awake} ->
            Enum.reduce(last_dt.minute..(new_dt.minute - 1), min_map, fn min, min_map ->
              Map.update(min_map, min, 1, &(&1 + 1))
            end)

          _ ->
            min_map
        end

      {new_min_map, new_state, new_dt}
    end)
    |> elem(0)
    |> Enum.max_by(fn {_min, times} -> times end, fn -> {0, 0} end)
  end

  def part1(input) do
    guard_map = parse_events(input)

    {sleepiest, _mins_asleep} =
      guard_map
      |> Enum.max_by(fn {_num, events} -> mins_asleep(events) end)

    {most_slept_min, _times} =
      guard_map
      |> Map.get(sleepiest)
      |> most_sleepy_min()

    most_slept_min * String.to_integer(sleepiest)
  end

  def part2(input) do
    input
    |> parse_events()
    |> Enum.map(fn {guard, guard_events} ->
      {guard, most_sleepy_min(guard_events)}
    end)
    |> Enum.max_by(fn {_guard, {_min, times}} -> times end)
    |> then(fn {guard, {min, _times}} -> String.to_integer(guard) * min end)
  end
end
