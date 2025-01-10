defmodule AdventOfCode.Day21 do
  @shop "Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3"

  def parse_shop() do
    [weapons, armor, rings] =
      @shop
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn section ->
        section
        |> String.replace(" +", "+")
        |> String.split([" ", "\n"], trim: true)
        |> Enum.chunk_every(4)
        |> tl()
      end)

    none = ["0", "0", "0"]

    [
      weapons,
      [["No armor" | none] | armor],
      [["No Ring1" | none], ["No Ring2" | none] | rings]
    ]
  end

  def combinations([]), do: [[]]

  def combinations([list | rest]) do
    for item <- list,
        comb <- combinations(rest) do
      [item | comb]
    end
  end

  def possible_shops(parsed_shop) do
    [weapons, armor, rings] = parsed_shop
    # because you can have two rings. FOOL!
    # Then have to filter in case choose the same ring twice
    combinations([weapons, armor, rings, rings])
    |> Enum.filter(&(length(Enum.uniq(&1)) == length(&1)))
    |> Enum.uniq()
    |> Enum.map(fn shop ->
      shop
      |> Enum.reduce({[], 0, 0, 0}, fn [name | nums], {names, tcost, tdmg, tarmor} ->
        [cost, dmg, armor] = Enum.map(nums, &String.to_integer/1)
        {[name | names], tcost + cost, tdmg + dmg, tarmor + armor}
      end)
    end)
  end

  def parse_boss(str) do
    Regex.scan(~r/\d+/, str)
    |> Enum.map(fn [str] -> String.to_integer(str) end)
    |> List.to_tuple()
  end

  def attack({_player_hp, player_dmg, _player_armor}, {boss_hp, boss_dmg, boss_armor}) do
    # variables named as if player turn but symetrical
    damage = max(player_dmg - boss_armor, 1)
    new_hp = max(boss_hp - damage, 0)
    {new_hp, boss_dmg, boss_armor}
  end

  def fight(player_stats, boss_stats, turn \\ :player_turn)

  def fight({0, _, _}, _boss_stats, _turn), do: :loss
  def fight(_p_stats, {0, _, _}, _turn), do: :win

  def fight(player_stats, boss_stats, turn) do
    # IO.inspect({turn, player_stats, boss_stats})

    case turn do
      :player_turn ->
        new_boss_stats = attack(player_stats, boss_stats)
        fight(player_stats, new_boss_stats, :boss_turn)

      :boss_turn ->
        new_player_stats = attack(boss_stats, player_stats)
        fight(new_player_stats, boss_stats)
    end
  end

  def find_results(possible_shops, boss) do
    possible_shops
    |> Enum.map(fn {stuff, cost, dmg, armor} ->
      {cost, stuff, fight({100, dmg, armor}, boss)}
    end)
  end

  def part1(args) do
    boss = parse_boss(args)

    parse_shop()
    |> possible_shops()
    |> find_results(boss)
    |> Enum.filter(fn {_cost, _stuff, result} -> result == :win end)
    |> Enum.min_by(fn {cost, _stuff, _result} -> cost end)
  end

  def part2(args) do
    boss = parse_boss(args)

    parse_shop()
    |> possible_shops()
    |> find_results(boss)
    |> Enum.filter(fn {_cost, _stuff, result} -> result == :loss end)
    |> Enum.max_by(fn {cost, _stuff, _result} -> cost end)
    |> elem(0)
  end
end
