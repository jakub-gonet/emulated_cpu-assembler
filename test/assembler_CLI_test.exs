defmodule AssemblerCLITest do
  use ExUnit.Case

  import Assembler.CLI, only: [parse_args: 1]

  test ":help returned if passed -h or --help" do
    assert parse_args(["-h"]) == :help
    assert parse_args(["--help"]) == :help
    assert parse_args(["-h", "output.ecpu", "input.ecpu"]) == :help
    assert parse_args(["-h", "output.ecpu"]) == :help
  end

  test ":help returned if no or too much args" do
    assert parse_args(["A", "A", "A", "A"]) == :help
    assert parse_args([]) == :help
  end

  test "2 args tuple returned if passed input and output" do
    assert parse_args(["input.ecpu", "output.cecpu"]) ==
      {"input.ecpu", "output.cecpu"}
  end
end
