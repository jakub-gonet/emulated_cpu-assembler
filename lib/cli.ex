defmodule Assembler.CLI do
@moduledoc """
Manages CLI parsing and calls converting functions to
generate compiled emulated CPU file (.ecpu)
"""

@doc """
Entry pount for a application
"""
def run(argv) do
  parse_args(argv)
end

@doc """
Function takes as argument a input file path, optionally output file path.

'argv' can also be -h or --help, which returns ':help'.

Returns a tuple of '{input_file, output_file}' or ':help'.
"""
def parse_args(argv) do
  parse = OptionParser.parse(argv, switches: [help: :boolean],
                                    aliases: [h:    :help   ])

  case parse do
    {[help: true], _, _} ->
      :help

    {_, [input_file, output_file], _} ->
      {input_file, output_file}

    _ ->:help
  end
end

def parseCode(str) do
  Parser.parse(str)
end

end
