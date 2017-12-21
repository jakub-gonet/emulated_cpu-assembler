defmodule Parser do
  @spec parse(binary) :: list
  def parse(str) do
    {:ok, tokens, _} = str |> to_charlist() |> :assembler_lexer.string()
    {:ok, list} = :assembler_parser.parse(tokens)
    list
  end

  def tokenize(str) do
    {:ok, tokens, _} = str |> to_charlist() |> :assembler_lexer.string()
    tokens
  end
end
