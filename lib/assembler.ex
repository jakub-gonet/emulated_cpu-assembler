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
  def hello do
    :world
  end
end
