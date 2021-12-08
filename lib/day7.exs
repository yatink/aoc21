defmodule Day7 do

  def parse_input(inpt) do
    positions = inpt |> String.split(",")
    for pos <- positions, do: elem(Integer.parse(pos), 0)
  end

  
  def part1(inpt) do
    positions = Enum.sort(parse_input(inpt))
    l = length(positions)
    medians = if rem(l, 2) == 0 do
      [trunc(l / 2), trunc(l/2) - 1] |>
        Enum.map(fn x -> positions |> Enum.at(x) end)
    else
      [positions |> Enum.at(trunc(l / 2))]
    end |> IO.inspect
    diff_totals = for median <- medians do
      Enum.sum(positions |> Enum.map(fn x -> abs(x - median) end))
    end
    Enum.zip(medians, diff_totals) |> IO.inspect
    Enum.min(diff_totals)    
  end

  def calc_sum(x), do: x * (x + 1) / 2
  
  def part2(inpt) do
    positions = parse_input(inpt)
    l = length(positions)
    mean_flt = Enum.sum(positions) / l |> IO.inspect
    means = trunc(mean_flt) - 10..round(mean_flt) + 10 |> IO.inspect
    diff_totals = for mean <- means do
      Enum.sum(positions |>
        Enum.map(fn x -> calc_sum(abs(x-mean)) end)) |> IO.inspect
    end
    Enum.zip(means, diff_totals) |> IO.inspect
    Enum.min(diff_totals)    
    
  end
end
