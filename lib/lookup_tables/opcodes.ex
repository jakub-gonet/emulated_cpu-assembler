defmodule LookupTable.Opcodes do
@moduledoc """
Contains lookup table for opcodes and functions getting values from them
"""

@opcodes %{
  NOP:    %{number: 0,  required_args: 0},
  HLT:    %{number: 1,  required_args: 0},
  MOV:    %{number: 2,  required_args: 2},
  JMP:    %{number: 3,  required_args: 1},
  JE:     %{number: 4,  required_args: 1},
  JNE:    %{number: 5,  required_args: 1},
  JL:     %{number: 6,  required_args: 1},
  JLE:    %{number: 7,  required_args: 1},
  JG:     %{number: 8,  required_args: 1},
  JGE:    %{number: 9,  required_args: 1},
  PUSH:   %{number: 10,  required_args: 1},
  POP:    %{number: 11,  required_args: 1},
  INC:    %{number: 12, required_args: 1},
  DEC:    %{number: 13, required_args: 1},
  ADD:    %{number: 14, required_args: 2},
  SUB:    %{number: 15, required_args: 2},
  MUL:    %{number: 16, required_args: 2},
  DIV:    %{number: 17, required_args: 2},
  AND:    %{number: 18, required_args: 2},
  OR:     %{number: 19, required_args: 2},
  XOR:    %{number: 20, required_args: 2},
  NOT:    %{number: 21, required_args: 1},
  RSHFT:  %{number: 22, required_args: 2},
  LSHFT:  %{number: 23, required_args: 2},
  CMP:    %{number: 24, required_args: 2}
}

@doc """
Gets opcode details from lookup table.

Returns tuple: {:ok, <opcode tuple>} or :error}
"""
def get_opcode(opcode) do
   Map.fetch(@opcodes, opcode)
end

@doc """
Gets required arguments number from given opcode

Returns required arguments number
"""
def get_required_arguments_number({:ok, opcode_tuple}), do:
  opcode_tuple.required_args
def get_required_arguments_number(_), do: {:error, :wrong_arg_type}
@doc """
Gets opcode number from given opcode

Returns opcode number or
"""
def get_opcode_number({:ok, opcode_tuple}), do:
  opcode_tuple.number
def get_opcode_number(_), do: {:error, :wrong_arg_type}

end
