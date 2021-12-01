defmodule Day1 do
  import Helpers
  def parse_line(line), do: elem(Integer.parse(line), 0)

  def find_increasing_values(lst) do
    [_ | tl] = lst
    Enum.zip_reduce(
      lst, tl, 0, fn x,y,acc -> if y > x, do: acc + 1, else: acc end)
  end  
  
  def part1(input) do
    lst = read_lines(input, &parse_line/1)
    find_increasing_values(lst)
  end

  def part2(input) do
    lst = read_lines(input, &parse_line/1)
    [_ | tl1] = lst
    [_ | tl2] = tl1
    window_avgs = Enum.zip_with([lst, tl1, tl2], fn [x,y,z] -> x + y + z end)
    find_increasing_values(window_avgs)
  end
end