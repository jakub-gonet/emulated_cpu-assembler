defmodule Assembler do
  @moduledoc """
    Assembler is used to assembly .ecpu files into compiled form for
    Emulated CPU.

    EBN form for this language is like following:

    letter = "A" | "B" | "C" | "D" | "E" | "F" | "G"
       | "H" | "I" | "J" | "K" | "L" | "M" | "N"
       | "O" | "P" | "Q" | "R" | "S" | "T" | "U"
       | "V" | "W" | "X" | "Y" | "Z" | "a" | "b"
       | "c" | "d" | "e" | "f" | "g" | "h" | "i"
       | "j" | "k" | "l" | "m" | "n" | "o" | "p"
       | "q" | "r" | "s" | "t" | "u" | "v" | "w"
       | "x" | "y" | "z" | "0" | "1" | "2" | "3"
       | "4" | "5" | "6" | "7" | "8" | "9" | "@"
       | "#" | "!" | "_";

    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
    whitespace = "\ " | "\t" | "\n";

    program = {assigment},{command},"HLT";

    command = opcode, whitespace,
            [(register | address | address in register),[ ",",
            (register | address | address in register | const)]]
    assigment = identifier, "<=", number, whitespace;
    identifier = letter, {letter | digit};
    label = identifier, ":", whitespace;
    number = ["-"], digit, {digit};


    where:
    definition	=
    concatenation	,
    termination	;
    alternation	|
    optional	[ ... ]
    repetition	{ ... }
    grouping	( ... )
    terminal string	" ... "
    terminal string	' ... '
    comment	(* ... *)
    special sequence	? ... ?
    exception	-
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
  INC:    %{number: 10, required_args: 1},
  DEC:    %{number: 11, required_args: 1},
  ADD:    %{number: 12, required_args: 2},
  SUB:    %{number: 13, required_args: 2},
  MUL:    %{number: 14, required_args: 2},
  DIV:    %{number: 15, required_args: 2},
  AND:    %{number: 16, required_args: 2},
  OR:     %{number: 17, required_args: 2},
  XOR:    %{number: 18, required_args: 2},
  NOT:    %{number: 19, required_args: 1},
  RSHFT:  %{number: 20, required_args: 2},
  LSHFT:  %{number: 21, required_args: 2},
  CMP:    %{number: 22, required_args: 2}
}

@addressing_modes %{
  CONST            => 0,
  REG              => 1,
  ADDR             => 2,
  ADDR_IN_REGISTER => 3
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

Returns required arguments number or :error with message
"""
def get_required_arguments(:error), do:
  error_opcode_doesnt_exist()
def get_required_arguments({:ok, opcode_tuple}), do:
  {:ok, opcode_tuple.required_args}

@doc """
Gets opcode number from given opcode

Returns opcode number or :error with message
"""
def get_opcode_number(:error), do:
  error_opcode_doesnt_exist()
def get_opcode_number({:ok, opcode_tuple}) do
  {:ok, opcode_tuple.number}
end

@doc """
Gets addressing mode number

Returns addressing mode number or :error with message
"""
def get_addressing_mode_number(addressing_mode) do
  Map.fetch(@addressing_modes, addressing_mode)
end

def error_opcode_doesnt_exist() do
  IO.puts("That opcode does not exist")
  :error
end

end
