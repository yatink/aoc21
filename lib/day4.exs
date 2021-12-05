defmodule Day4 do
  def parse_input(inpt) do
    [nums | boards] = inpt |> String.split("\n\n")
    nums = nums |> String.split(",")
    board_rows = boards |> Enum.map(
      fn whole ->
        for row <- String.split(whole, "\n") do
          row |> String.split(" ", trim: true)
        end
      end)
    board_rows_set = for board <- board_rows do
      for row <- board, do: MapSet.new(row)
    end
    board_cols = board_rows |> Enum.map(fn brd -> Enum.zip(brd) end)
    board_cols = for board <- board_cols do
      for col <- board, do: MapSet.new(col |> Tuple.to_list)
    end
    {nums, Enum.zip(board_rows_set, board_cols)}    
  end

  def empty_row?(row), do: length(row |> MapSet.to_list) == 0
  
  def check_win(board) do
    Enum.any?(board, &empty_row?/1)
  end

  def cross_out_element(board, num) do
    updated_board = for row <- board, do: row |> MapSet.delete(num)
    {updated_board, check_win(updated_board)}
  end

  def play_number(num, boards) do
    for {r, c} <- boards, do: {r |> cross_out_element(num), c |> cross_out_element(num)}
  end
    
  def play([num|nums], boards) do
    updated_boards = play_number(num, boards)
    case Enum.find(
          updated_boards,
          fn {{_, r_win}, {_, c_win}} -> r_win or c_win end) do
      nil -> updated_boards = updated_boards |> Enum.map(fn {{r, _}, {c, _}} -> {r, c} end)
        play(nums, updated_boards)
      {{r, _}, _} -> {r, num}
    end
  end  

  def play_to_lose([num|nums], boards) do
    num |> IO.inspect(label: "num")
    updated_boards = play_number(num, boards)
    losing_boards = Enum.reject(
      updated_boards,
      fn {{_, r_win}, {_, c_win}} -> r_win or c_win end)
    case losing_boards do
      [{{r, _}, {c, _}}] -> {{r, c}, nums}
      _ -> play_to_lose(nums |> IO.inspect(label: "nums"), losing_boards|> Enum.map(fn {{r, _}, {c, _}} -> {r, c} end) |> IO.inspect(label: "losing_boards"))
    end
  end
  
  def part1(inpt) do
    {nums, boards} = parse_input(inpt)
    {board, num} = play(nums, boards)
    board = for n <- Enum.concat(for row <- board, do: MapSet.to_list(row)) do
      elem(Integer.parse(n), 0)
    end
    Enum.sum(board) * elem(Integer.parse(num), 0)
  end

  def part2(inpt) do
    {nums, boards} = parse_input(inpt)
    {losing_board, remaining_nums} = play_to_lose(nums, boards) |> IO.inspect
    {board, num} = play(remaining_nums, [losing_board]) |> IO.inspect
    board = for n <- Enum.concat(for row <- board, do: MapSet.to_list(row)) do
      elem(Integer.parse(n), 0)
    end
    Enum.sum(board) * elem(Integer.parse(num), 0)
  end
end
