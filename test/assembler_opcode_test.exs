defmodule Assembler.OpcodeTest do
  use ExUnit.Case, async: true
  import Assembler.Opcode

test "split_operation_into_numbers/1" do
  assert split_operation_into_numbers([:MOV, [:REGISTER, 3], [:CONST, 2]]) == [2,1,0]
  assert split_operation_into_numbers([:MOV, [:CONST, 2]]) == [2,0,0]
  assert split_operation_into_numbers([:MOV]) == [2,0,0]
  assert split_operation_into_numbers([]) == [0,0,0]

  assert split_operation_into_numbers(:hi) == {:error, :wrong_arg_type}
end

test "create_opcode_number/1" do
  assert create_opcode_number([3,0,0]) == 0xc0
  assert create_opcode_number([2,1,0]) == 0x88

  assert create_opcode_number([3,0]) == {:error, :bad_args_number}
  assert create_opcode_number(:hey) == {:error, :wrong_arg_type}
end

test "valid_args_number?/2" do
  assert valid_args_number?(:MOV, [0,0]) == :ok
  assert valid_args_number?(:MOV, [0]) == {:error, :bad_args_number, :MOV}
end

test "opcode_exists?/1" do
  assert opcode_exists?(:MOV) == :ok
  assert opcode_exists?(:NOP) == :ok

  assert opcode_exists?(:NUP) == {:error, :opcode_doesnt_exist, :NUP}
end

end
