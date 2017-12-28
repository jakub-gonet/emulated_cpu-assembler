defmodule Parser do
@moduledoc """
Parser is used to parse and tokenize given string to proper form used by app.
"""

  @doc """
  Given tokenized form parses it to form required by functions in other modules.
  """
  def parse(tokenized), do: :assembler_parser.parse(tokenized)

  @doc """
  Given string, returns tokenized version
  """
  def tokenize(str) do
    str
      |> to_charlist
      |> :assembler_lexer.string
  end
end
