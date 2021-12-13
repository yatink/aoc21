defmodule Day12 do
  import Helpers
  def parse_line(line), do: line |> String.split("-")

  def traverse(paths, "end", _) do
    1
  end
  def traverse(paths, node, small_nodes_visited) do
    if node =~ ~r([a-z]+) and node != "start" do # Small node
      if node in small_nodes_visited do
        0
      else
        Enum.sum(
          for next <- paths[node] do
            traverse(paths, next, small_nodes_visited |> MapSet.put(node))
          end)
      end
    else # Big node or start node
      Enum.sum(
        for next <- paths[node] do
          traverse(paths, next, small_nodes_visited)
        end)
    end
  end

  def traverse(_, "end", _, _), do: 1
  def traverse(paths, node, small_nodes_visited, double_node) do
    if node =~ ~r([a-z]+) and node != "start" do # Small node
      if node in small_nodes_visited do
        if double_node == nil do
          Enum.sum(
            for next <- paths[node] do
              traverse(paths, next, small_nodes_visited, node)
            end)
        else
          0
        end
      else
        Enum.sum(
          for next <- paths[node] do
            traverse(paths, next, small_nodes_visited |> MapSet.put(node), double_node)
          end)
      end
    else # Big node or start node
      Enum.sum(
        for next <- paths[node] do
          traverse(paths, next, small_nodes_visited, double_node)
        end)
    end
  end
  
  def part1(inpt) do
    lst = read_lines(inpt, &parse_line/1)
    paths = lst |> Enum.reduce(
      %{},
      fn [s,e], acc ->
        if s == "end" or e == "start" do
          acc
        else
          acc |> Map.put(s, [e | Map.get(acc, s, [])])
        end
      end)
    paths = lst |> Enum.reduce(
      paths,
      fn [s,e], acc ->
        if s == "start" or e == "end" do
          acc
        else
          acc |> Map.put(e, [s | Map.get(acc, e, [])])
        end
      end)
    traverse(paths, "start", MapSet.new([]))
  end

  def part2(inpt) do
    lst = read_lines(inpt, &parse_line/1)
    paths = lst |> Enum.reduce(
      %{},
      fn [s,e], acc ->
        if s == "end" or e == "start" do
          acc
        else
          acc |> Map.put(s, [e | Map.get(acc, s, [])])
        end
      end)
    paths = lst |> Enum.reduce(
      paths,
      fn [s,e], acc ->
        if s == "start" or e == "end" do
          acc
        else
          acc |> Map.put(e, [s | Map.get(acc, e, [])])
        end
      end)
    traverse(paths, "start", MapSet.new([]), nil)
  end

end
