defmodule Assembler.ArgumentsTest do
  use ExUnit.Case
  import Assembler.Arguments, only: [get_args_values: 1]

  test "passed valid args" do
    assert get_args_values([[:REGISTER, 2], [:CONST, 3]]) == {:ok, [2, 3]}
  end

end
