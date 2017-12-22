defmodule Parser do
  @spec parse(binary) :: list
  def parse(str) do
    {:ok, list} = str
                  |> tokenize()
                  |> :assembler_parser.parse()
    list
  end

  def tokenize(str) do
    {:ok, tokens, _} = str
                        |> to_charlist()
                        |> :assembler_lexer.string()
    tokens
  end
end
