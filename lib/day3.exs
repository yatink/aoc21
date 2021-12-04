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
    processed = read_lines(inpt, &parse_line/1)
    # transpose then convert tuples to lists
    trnsps = Enum.zip(processed) |> Enum.map(&Tuple.to_list/1) |> IO.inspect
    cnts = trnsps |> Enum.map(&counts/1)
    gamma = cnts |> Enum.map(fn %{"0"=>x, "1"=>y} ->if x > y, do: 0, else: 1 end) |> IO.inspect
    epsilon = cnts |> Enum.map(fn %{"0"=>x, "1"=>y} ->if x < y, do: 0, else: 1 end) |> IO.inspect
    {gamma, _} = gamma |> Enum.join |> Integer.parse(2)
    {epsilon, _} = epsilon |> Enum.join |> Integer.parse(2)
    gamma * epsilon
  end
 
  def part2_proc(numbers, what_if_equal, bit_position \\ 0) do
    trnsps = Enum.zip(processed) |> Enum.map(&Tuple.to_list/1) |> IO.inspect
    check = case counts(trnsps |> Enum.at(bit_position) do
      %{"0" => x, "1" => x} -> what_if_equal
      %{"0" => x, "1" => y} when x > y -> "0"
      _ -> "1"
    end
    filtered = numbers |> Enum.filter(fn num -> num |> Enum.at(bit_position) == check end)
    if length(filtered) == 1 do
      hd(filtered)
    else
      part2_proc(filtered, what_if_equal, bit_position + 1)
    end
  end

  def part2(inpt) do
    processed = read_lines(inpt, &parse_line/1)
    o2 = part2_proc(processed, 1)
    co2 = part2_proc(processed, 0)
  end
end