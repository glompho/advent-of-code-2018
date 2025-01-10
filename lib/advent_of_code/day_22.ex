defmodule AdventOfCode.Day22 do
  def parse_boss(str) do
    Regex.scan(~r/\d+/, str)
    |> Enum.map(fn [str] -> String.to_integer(str) end)
    |> List.to_tuple()
  end

  def magic_missile({{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    {{hp, mana}, {boss_hp - 4, dmg}, effects, mana_used}
  end

  def drain({{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    {{hp + 2, mana}, {boss_hp - 2, dmg}, effects, mana_used}
  end

  def add_effect({effect, turns}, effects) do
    case Map.get(effects, effect) do
      {effect, 0} -> Map.put(effects, effect, turns)
      nil -> Map.put(effects, effect, turns)
      _ -> effects
    end
  end

  def shield({{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    {{hp, mana}, {boss_hp, dmg}, add_effect({:shield, 6}, effects), mana_used}
  end

  def poison({{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    {{hp, mana}, {boss_hp, dmg}, add_effect({:poison, 6}, effects), mana_used}
  end

  def recharge({{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    {{hp, mana}, {boss_hp, dmg}, add_effect({:recharge, 5}, effects), mana_used}
  end

  def boss_attack({{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    turn_dmg =
      cond do
        boss_hp <= 0 -> 0
        Map.has_key?(effects, :shield) -> dmg - 7
        true -> dmg
      end

    {{hp - turn_dmg, mana}, {boss_hp, dmg}, effects, mana_used}
  end

  def hard_mode({{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    if Map.has_key?(effects, :hard_mode) do
      {{hp - 1, mana}, {boss_hp, dmg}, effects, mana_used}
    else
      {{hp, mana}, {boss_hp, dmg}, effects, mana_used}
    end
  end

  def do_effects({{_hp, _mana}, {_boss_hp, _dmg}, effects, _mana_used} = state) do
    Enum.reduce(effects, state, fn
      {effect, turns}, state ->
        do_one_effect({effect, turns}, state)
    end)
  end

  def prune_effects({{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    new_effects =
      effects
      |> Enum.filter(fn {_effect, turns} -> turns > 0 end)
      |> Map.new()

    {{hp, mana}, {boss_hp, dmg}, new_effects, mana_used}
  end

  def do_one_effect({effect, turns}, {{hp, mana}, {boss_hp, dmg}, effects, mana_used}) do
    new_effects = Map.put(effects, effect, turns - 1)

    case {effect, turns} do
      {_, 0} ->
        {{hp, mana}, {boss_hp, dmg}, new_effects, mana_used}

      {:poison, _} ->
        {{hp, mana}, {boss_hp - 3, dmg}, new_effects, mana_used}

      {:recharge, _} ->
        {{hp, mana + 101}, {boss_hp, dmg}, new_effects, mana_used}

      {:shield, _} ->
        {{hp, mana}, {boss_hp, dmg}, new_effects, mana_used}

      {:hard_mode, _} ->
        # Don't prune
        {{hp, mana}, {boss_hp, dmg}, effects, mana_used}
    end
  end

  def simulate_game(initial_state) do
    spells = [
      {&recharge/1, 229},
      {&drain/1, 73},
      {&shield/1, 113},
      {&poison/1, 173},
      {&magic_missile/1, 53}
    ]

    queue = :queue.from_list([{initial_state, :player_turn}])
    simulate_turns(queue, spells, nil)
  end

  def simulate_turns(queue, spells, best_win) do
    case :queue.out(queue) do
      {:empty, _} ->
        best_win

      {{:value, {state, turn}}, queue} ->
        {{hp, _mana}, {boss_hp, _}, _effects, mana_used} = state

        cond do
          # If we already found a better solution, skip this branch
          best_win != nil && mana_used >= elem(best_win, 1) ->
            simulate_turns(queue, spells, best_win)

          boss_hp <= 0 ->
            # Found a win, update best_win if it's better
            new_best =
              if best_win == nil or mana_used < elem(best_win, 1),
                do: {:win, mana_used},
                else: best_win

            simulate_turns(queue, spells, new_best)

          hp <= 0 ->
            simulate_turns(queue, spells, best_win)

          true ->
            new_queue = process_turn(state, turn, queue, spells)
            simulate_turns(new_queue, spells, best_win)
        end
    end
  end

  def process_turn(state, :player_turn, queue, spells) do
    {{hp, mana}, {boss_hp, dmg}, effects, mana_used} = state

    Enum.reduce(spells, queue, fn {spell, cost}, acc_queue ->
      new_mana = mana - cost
      new_mana_used = mana_used + cost

      if new_mana < 0 do
        acc_queue
      else
        new_state =
          {{hp, new_mana}, {boss_hp, dmg}, effects, new_mana_used}
          |> do_effects()
          |> prune_effects()
          |> spell.()

        :queue.in({new_state, :boss_turn}, acc_queue)
      end
    end)
  end

  def process_turn(state, :boss_turn, queue, _spells) do
    new_state =
      state
      |> do_effects()
      |> boss_attack()
      |> prune_effects()
      |> hard_mode()

    :queue.in({new_state, :player_turn}, queue)
  end

  def part1(args) do
    boss = parse_boss(args)
    initial_state = {{50, 500}, boss, %{}, 0}

    simulate_game(initial_state)
  end

  def part2(args) do
    boss = parse_boss(args)
    initial_state = {{49, 500}, boss, %{:hard_mode => 1}, 0}

    simulate_game(initial_state)
  end
end
