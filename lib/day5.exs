defmodule Day5 do
  import Helpers

  def parse_line(line) do
    [[x1, y1], [x2, y2]] = line
      |> String.split(" -> ") |> IO.inspect 
      |> Enum.map(fn x -> x |> String.split(",") end)
    {
      {
        elem(Integer.parse(x1), 0),
        elem(Integer.parse(y1), 0)
      },
      {
        elem(Integer.parse(x2), 0),
        elem(Integer.parse(y2), 0)
      },
    }      
  end

  def horizontal_vertical?({{x, _}, {x, _}}), do: true
  def horizontal_vertical?({{_, y}, {_, y}}), do: true
  def horizontal_vertical?(_), do: false

  def diagonal?({{x1, y1}, {x2, y2}}) when y1 - x1 == y2 - x2, do: true
  def diagonal?({{x1, y1}, {x2, y2}}) when x1 + y1 == x2 + y2, do: true
  def diagonal?(_), do: false
  
  def draw_line({{x, y1}, {x, y2}}) do
    for y <- y1..y2, do: {x, y}
  end
  def draw_line({{x1, y}, {x2, y}}) do
    for x <- x1..x2, do: {x, y}
  end

  # Positive slope diagonal
  def draw_line({{x1, y1}, {x2, y2}}) when y1 - x1 == y2 - x2 do
    diff = y1 - x1
    for y <- y1..y2, do: {y - diff, y}
  end

  # Negative slope diagonal
  def draw_line({{x1, y1}, {x2, y2}}) when y1 + x1 == y2 + x2 do
    sum = y1 + x1
    for y <- y1..y2, do: {sum - y, y}
  end

  def part1(inpt) do
    inpt = read_lines(inpt, &parse_line/1)
    non_diagonals = inpt |>
      Enum.filter(&horizontal_vertical?/1)
    paths = non_diagonals |>
      Enum.flat_map(&draw_line/1) |> # All points in the line
      Enum.frequencies # How often each point is visited
    length(
      paths |> Map.values |> Enum.filter(fn x -> x > 1 end))
  end

  def part2(inpt) do
    inpt = read_lines(inpt, &parse_line/1)
    non_diagonals = inpt |>
      Enum.filter(&horizontal_vertical?/1)
    diagonals = inpt |>
      Enum.filter(&diagonal?/1)
    paths = diagonals ++ non_diagonals |>
      Enum.flat_map(&draw_line/1) |> # All points in the line
      Enum.frequencies # How often each point is visited
    length(
      paths |> Map.values |> Enum.filter(fn x -> x > 1 end))
  end
end
