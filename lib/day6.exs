defmodule Day6 do

  def parse_input(inpt) do
    fishes = inpt |> String.split(",")
    for fish <- fishes, do: elem(Integer.parse(fish), 0)
  end

  def tick(fishes) do
    updated_fishes = fishes |> Enum.map(fn x -> x - 1 end)
    new_fishes = length(updated_fishes |>
      Enum.filter(fn x -> x < 0 end))
    updated_fishes = updated_fishes |>
      Enum.map(fn x -> if x == -1, do: 6, else: x end)
    updated_fishes ++ List.duplicate(8, new_fishes)
  end

  def tick_until(fishes, 0), do: fishes
  def tick_until(fishes, num), do: tick_until(fishes |> tick, num - 1)
 
  def total_fish(_, acc, 0), do: acc
  def total_fish(f, acc, ticks) when f >= ticks, do: acc
  def total_fish(f, acc, ticks) when f < ticks-1 and ticks < 7, do: acc+1
  def total_fish(f, acc, ticks) when ticks >= 7 do
    case f do
      8 -> total_fish(1, acc, ticks - 7)
      7 -> total_fish(0, acc, ticks - 7)
      _ -> total_fish(f + 2, acc + 1, ticks - 7)
    end
  end

  def transform({0, n}), do: %{6 => n, 8 => n}
  def transform({x, n}) when x <= 8, do: %{x - 1 => n}

  def take_step(fishes, 0), do: fishes
  def take_step(fishes, steps) do
    updated_fishes = Map.to_list(fishes) |> Enum.reduce(
      %{},
      fn {k, n}, acc -> Map.merge(
        acc, transform({k, n}), fn _k, v1, v2 ->
          if v1 == nil do
            v2
          else
            v1 + v2
          end
        end)        
      end)
    take_step(updated_fishes, steps - 1)
  end
  
  def part1(inpt, days \\ 80) do
    fishes = parse_input(inpt)
    length(tick_until(fishes, days))
  end

  def part2(inpt, days) do
    fishes = parse_input(inpt)
    fish_map = fishes |> Enum.frequencies
    take_step(fish_map, days) |> Map.values |> Enum.sum
  end
end
