defmodule Day8 do
  import Helpers


  @numbers %{
    {:BR, :TR} => 1,
    {:B, :BL, :M, :T, :TR} => 2,
    {:B, :BR, :M, :T, :TR} => 3,
    {:BR, :M, :TL, :TR} => 4,
    {:B, :BR, :M, :T, :TL} => 5,
    {:B, :BL, :BR, :M, :T, :TL} => 6,
    {:BR, :T, :TR} => 7,
    {:B, :BL, :BR, :M, :T, :TL, :TR} => 8,
    {:B, :BR, :M, :T, :TL, :TR} => 9,
    {:B, :BL, :BR, :T, :TL, :TR} => 0
  }
  
  def parse_line1(inpt) do
    inpt |> String.split(" | ")
  end
  
  def part1(inpt) do
    lines = read_lines(inpt, &parse_line1/1)
    lengths = Enum.concat(
      for [_,r] <- lines do
        r |> String.split(" ") |> Enum.map(&String.length/1)
      end)
    interesting = MapSet.new([2, 3, 4, 7])
    length(lengths |> Enum.filter(fn x -> x in interesting end))
  end

  def parse_line2(inpt) do
    [_, r] = inpt |> String.split(" | ")
    num = r |> String.split(" ") |> Enum.map(&String.graphemes/1)
    size_map = inpt
    |> String.split(" ")
    |> Enum.reject(fn x -> x == "|" end)
    |> Enum.map(fn x -> MapSet.new(x |> String.graphemes) end)
    |> Enum.group_by(&MapSet.size/1)
    {num, size_map |> identify_segments}
  end
  
  def identify_segments(proc_inpt) do
    segments = %{}
    proc_inpt[2]
    one = proc_inpt[2] |> Enum.at(0)
    seven = proc_inpt[3] |> Enum.at(0)
    four = proc_inpt[4] |> Enum.at(0)
    eight = proc_inpt[7] |> Enum.at(0)
    segments = segments |> Map.put_new(:T,
      seven |> MapSet.difference(one) |> MapSet.to_list |> Enum.at(0))
    segments = segments |> Map.put_new(:B,
      for num <- proc_inpt[6] do
        num |>
          MapSet.difference(four) |>
          MapSet.delete(segments[:T])
      end |> Enum.find(fn x -> MapSet.size(x) == 1 end) |> MapSet.to_list |> Enum.at(0))
    segments = segments |> Map.put_new(:BL,
      eight |>
        MapSet.difference(four) |>
        MapSet.delete(segments[:T]) |>
        MapSet.delete(segments[:B]) |>
        MapSet.delete(segments[:BL]) |>
        MapSet.to_list |> Enum.at(0))
    segments = segments |> Map.put_new(:M,
      for num <- proc_inpt[5] do
        num |>
          MapSet.difference(one) |>
          MapSet.delete(segments[:T]) |>
          MapSet.delete(segments[:B])
      end |> Enum.find(fn x -> MapSet.size(x) == 1 end) |> MapSet.to_list |> Enum.at(0))
    segments = segments |> Map.put_new(:TL,
      four |>
        MapSet.difference(one) |>
        MapSet.delete(segments[:M]) |> MapSet.to_list |> Enum.at(0))
    segments = segments |> Map.put_new(:TR,
      for num <- proc_inpt[6] do
        one |> MapSet.difference(num)
      end |> Enum.find(fn x -> MapSet.size(x) == 1 end) |> Enum.at(0))
    segments = segments |> Map.put_new(:BR,
      one |> MapSet.delete(segments[:TR]) |> MapSet.to_list |> Enum.at(0))
    for {k, v} <- segments, into: %{} do
      {v, k}
    end 
    
    
  end  
  
  def part2(inpt) do
    lines = read_lines(inpt, &parse_line2/1)
    actual_nums = for {nums, key} <- lines do
      for num <- nums do
        Map.get(
          @numbers,
          num |> 
            Enum.map(fn x -> key[x] end) |>
            Enum.sort |>
            List.to_tuple)
      end |> Enum.join("") |> Integer.parse |> elem(0)
    end
    Enum.sum(actual_nums)
    
  end
end
