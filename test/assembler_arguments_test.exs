defmodule Assembler.ArgumentsTest do
  use ExUnit.Case, async: true
  import Assembler.Arguments, only: [get_args_values: 1]

test "get_args_values/1" do
  assert get_args_values([[:REGISTER, 2], [:CONST, 3]]) == {:ok, [2, 3]}
  assert get_args_values([[:REGISTER, 3]]) == {:ok, [3]}
  assert get_args_values([]) == {:ok, []}

  assert get_args_values([[:REGISTER, 3], [:REGISTER, 3], [:REGISTER, 3]]) == {:ok, [3, 3, 3]}

  assert get_args_values([[:CONST, 3]]) == {:error, :first_arg_const, 3}
end

end
