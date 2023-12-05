defmodule AOC do
  def parse_line(line) do
    parts = Regex.split(~r/ +/, line)

    [_, card_num_str | numbers] = parts

    card_num = card_num_str |> String.slice(0..-2) |> String.to_integer()

    {winning_numbers, our_numbers_with_separator} =
      numbers |> Enum.split_while(fn x -> x !== "|" end)

    our_numbers = our_numbers_with_separator |> Enum.drop(1)

    {card_num, winning_numbers |> Enum.map(fn x -> String.to_integer(x) end),
     our_numbers |> Enum.map(fn x -> String.to_integer(x) end)}
  end

  def winning_tr(_winning_numbers, [], acc) do
    acc
  end

  def winning_tr(winning_numbers, our_numbers, acc) do
    [n | ns] = our_numbers

    winning_tr(
      winning_numbers,
      ns,
      if Enum.member?(winning_numbers, n) do
        [n | acc]
      else
        acc
      end
    )
  end

  def winning({_card_num, winning_numbers, our_numbers}) do
    winning_tr(winning_numbers, our_numbers, [])
  end

  def score([]) do
    0
  end

  def score(winnings) do
    Integer.pow(2, Enum.count(winnings) - 1)
  end

  def total_score(lines) do
    lines_list = String.split(lines, "\r\n")

    lines_list
    |> Enum.reduce(0, fn line, acc ->
      acc +
        (line |> parse_line() |> winning() |> score())
    end)
  end

  def main() do
    {_status, input} = File.read("input.txt")
    IO.puts(total_score(input))
  end
end

AOC.main()
