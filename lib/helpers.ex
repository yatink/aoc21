defmodule Helpers do
  def read_lines(str, f, trim \\ true) do
    for n <- String.split(str, "\n", trim: trim), do: f.(n)
  end
end