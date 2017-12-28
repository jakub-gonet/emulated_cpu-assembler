defmodule Assembler.CLI do
require Logger
@moduledoc """
Manages CLI parsing and calls converting functions to
generate compiled emulated CPU file (.ecpu)
"""

@doc """
Entry point for a application.

Function takes as argument a input file path, optionally output file path.
'argv' can also be -h or --help, which returns ':help'.

Writes compiled code to output file with extension .cecpu (compiled ecpu)
"""
def main(argv) do
  argv
    |> parse_args
    |> compile
end

def parse_args(argv) when is_list(argv) do
  parse = OptionParser.parse(argv, switches: [help: :boolean],
                                    aliases: [h:    :help   ])

  case parse do
    {[help: true], _, _} ->
      :help

    {_, [input_file, output_file], _} ->
      {input_file, output_file}
    {_, [input_file], _} ->
      {input_file}
    _ -> :help
  end
end

defp compile({:error, :no_extension}), do:
    Logger.error("File with .ecpu extension is required")
defp compile({input}), do:
  input |> createOutputFileName |> compile
defp compile({input, output}) do
  with true <- valid_filenames?(input, output),
       input <- Path.expand(input),
       output <- Path.expand(output),
       {:ok, content} <- File.read(input),
       {:ok, tokenized, _} <- Parser.tokenize(content),
       {:ok, parsed} <- Parser.parse(tokenized),
       {:ok, assembled} <- Assembler.assemble(parsed),
       assembled_str = Enum.join(assembled, ", ")
  do
    File.write(output, assembled_str)
  else
    {:error, reason} -> Logger.error("Error: #{inspect reason}")
    _ -> :error
  end
end

defp valid_filenames?(input, output) do
  alias Regex, as: R
  ecpu_ext = ~r{[^\s]+\.ecpu$}
  cecpu_ext = ~r{[^\s]+\.cecpu$}
  R.match?(ecpu_ext, input) and R.match?(cecpu_ext, output)
end

defp createOutputFileName(nil), do: {:error, :no_extension}
defp createOutputFileName(%{"name" => name}), do: {name<>".ecpu", name<>".cecpu"}
defp createOutputFileName(filename) do
  regex = ~r{(?<name>[^\s]+)\.ecpu$}
  match = Regex.named_captures(regex, filename)
  createOutputFileName(match)
end
end
