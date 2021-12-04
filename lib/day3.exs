defmodule Day3 do
  import Helpers

  def parse_line(line) do
  # convert to a list of single character strings
    String.graphemes(line)      
  end

  def counts(lst) do
    for {key, value} <- Enum.group_by(lst, fn x -> x end), into: %{} do
      {key, length(value)}
    end
  end

  def part1(inpt) do
    prcssd = read_lines(inpt, &parse_line/1)
    # transpose then convert tuples to lists
    trnsps = Enum.zip(prcssd) |> Enum.map(&Tuple.to_list/1) |> IO.inspect
    cnts = trnsps |> Enum.map(&counts/1)
    gamma = cnts |> Enum.map(fn %{"0"=>x, "1"=>y} ->if x > y, do: 0, else: 1 end) |> IO.inspect
    epsilon = cnts |> Enum.map(fn %{"0"=>x, "1"=>y} ->if x < y, do: 0, else: 1 end) |> IO.inspect
    {gamma, _} = gamma |> Enum.join |> Integer.parse(2)
    {epsilon, _} = epsilon |> Enum.join |> Integer.parse(2)
    gamma * epsilon
  end
 
  def part2_proc(numbers, comp, what_if_equal, bit_position \\ 0) do
    numbers |> Enum.map(&Enum.join/1) |> IO.inspect
    what_if_equal |> IO.inspect
    bit_position |> IO.inspect
    trnsps = Enum.zip(numbers) |> Enum.map(&Tuple.to_list/1)
    check = case counts(trnsps |> Enum.at(bit_position)) |> IO.inspect do
      %{"0" => x, "1" => x} -> what_if_equal
      %{"0" => x, "1" => y} -> if comp.(x,y), do: "0", else: "1"
      %{"0" => _} -> "0"
      %{"1" => _} -> "1"
    end
    filtered = numbers |> Enum.filter(fn num -> num |> Enum.at(bit_position) == check end)
    if length(filtered) == 1 do
      hd(filtered) |> IO.inspect
    else
      part2_proc(filtered, comp, what_if_equal, bit_position + 1)
    end
  end

  def part2(inpt) do
    prcssd= read_lines(inpt, &parse_line/1)
    # &>/2 : Represents the "greater than" function
    # &</2 : Represents the "less than" function
    # This notation was required in order to switch the
    # behaviour based on O2 vs CO2
    o2 = part2_proc(prcssd, &>/2, "1")
    co2 = part2_proc(prcssd, &</2, "0")
    {o2, _} = o2 |> Enum.join |> Integer.parse(2) |> IO.inspect
    {co2, _} = co2 |> Enum.join |> Integer.parse(2) |> IO.inspect
    o2 * co2
  end
end
