defmodule Day8 do
  import Helpers

  def parse_line(inpt) do
    inpt |> IO.inspect |> String.split(" |")
  end
  
  def part1(inpt) do
    lines = read_lines(inpt, &parse_line/1) |> IO.inspect
    lengths = Enum.concat(
      for [_,r] <- lines do
        r |> String.split(" ") |> IO.inspect |> Enum.map(&String.length/1)
      end |> IO.inspect)
    interesting = MapSet.new([2, 3, 4, 7])
    length(lengths |> Enum.filter(fn x -> x in interesting end))
  end

  def part2(inpt) do
      
  end
end
