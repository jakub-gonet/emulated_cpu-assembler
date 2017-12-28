defmodule Parser do
@moduledoc """
Parser is used to parse and tokenize given string to proper form used by app.
"""

  @doc """
  Given string parses it to form required by functions in other modules.
  """
  def parse(str) do
    {:ok, list} = str
                  |> tokenize()
                  |> :assembler_parser.parse()
    list
  end

  @doc """
  Given string tokenizes it, should be used only for debug reasons.
  """
  def tokenize(str) do
    {:ok, tokens, _} = str
                        |> to_charlist()
                        |> :assembler_lexer.string()
    tokens
  end
end
