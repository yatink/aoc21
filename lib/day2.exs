defmodule Day2 do
  import Helpers
  def parse_line(line) do
    [dir, steps] = String.split(line)
    {dir, elem(Integer.parse(steps), 0)}
  end

  def total_steps(dirs) do
    {_, steps} = Enum.unzip(dirs)
    Enum.sum(steps)
  end

  def part1(inpt) do
     lst = read_lines(inpt, &parse_line/1)
    horizontals = total_steps(
      Enum.filter(lst, fn {dir, _} -> dir == "forward" end))
    ups = total_steps(
      Enum.filter(lst, fn {dir, _} -> dir == "up" end))
    downs = total_steps(
      Enum.filter(lst, fn {dir, _} -> dir == "down" end))
    horizontals * (downs - ups)
  end
 
  def part2(inpt) do
    lst = read_lines(inpt, &parse_line/1)
    {hrzntl, _, depth} = Enum.reduce(
      lst,
      {0, 0, 0},
      fn {command, num}, {hrzntl, aim, depth} ->
        case command do
          "forward" -> {hrzntl + num, aim, depth + (aim * num)}
          "down" -> {hrzntl, aim + num, depth}
          "up" -> {hrzntl, aim - num, depth}
        end
      end)
    hrzntl * depth
  end
end