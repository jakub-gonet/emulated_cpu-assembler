defmodule LookupTable.OpcodeTest do
  use ExUnit.Case, async: true
  import LookupTable.Opcodes

test "get_opcode/1" do
  assert get_opcode(:MOV) == {:ok, %{number: 2,  required_args: 2}}
  assert get_opcode(:CMP) == {:ok, %{number: 22, required_args: 2}}

  assert get_opcode(:A) == :error
  assert get_opcode({}) == :error
end

test "get_required_arguments_number/1" do
  assert get_required_arguments_number({:ok, %{number: 2,  required_args: 2}}) == 2
  assert get_required_arguments_number({:ok, %{number: 0,  required_args: 0}}) == 0

  assert get_required_arguments_number(%{number: 2,  required_args: 2}) == {:error, :wrong_arg_type}
  assert get_required_arguments_number(%{number: 0,  required_args: 0}) == {:error, :wrong_arg_type}
  assert get_required_arguments_number(:error) == {:error, :wrong_arg_type}
  assert get_required_arguments_number("hi") == {:error, :wrong_arg_type}
end

test "get_opcode_number/1" do
  assert get_opcode_number({:ok, %{number: 3,  required_args: 2}}) == 3
  assert get_opcode_number({:ok, %{number: 15,  required_args: 0}}) == 15

  assert get_opcode_number(%{number: 2,  required_args: 2}) == {:error, :wrong_arg_type}
  assert get_opcode_number(%{number: 0,  required_args: 0}) == {:error, :wrong_arg_type}
  assert get_opcode_number(:error) == {:error, :wrong_arg_type}
  assert get_opcode_number("hi") == {:error, :wrong_arg_type}
end

end
