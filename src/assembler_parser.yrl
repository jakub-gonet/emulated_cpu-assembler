Nonterminals
  statements
  statement
  assigment
  operation
  identifer
  opcode
  label
  value
  regValue
  address
  regAddress.

Terminals
  int
  atom
  '\n'
  '['
  ']'
  ','
  '<='
  ':'
  '&'.

Rootsymbol statements.

statements -> statement                 : ['$1'].
statements -> statement '\n' statements : ['$1' | '$3'].

statement -> label     : {'label', '$1'}.
statement -> assigment : {'assigment', '$1'}.
statement -> operation : {'operation', '$1'}.

label -> identifer ':' : '$1'.

assigment -> identifer '<=' value   : {'$1', '$3'}.

operation -> opcode value ',' value : {'$1', '$2', '$4'}.
operation -> opcode value           : {'$1', '$2'}.
operation -> opcode identifer       : {'$1', '$2'}.
operation -> opcode                 : {'$1'}.

identifer -> atom   : unwrap('$1').

value -> int        : unwrap('$1').
value -> regValue   : '$1'.
value -> address    : '$1'.
value -> regAddress : '$1'.

opcode -> atom : unwrap('$1').

regValue -> '[' int ']'       : {'register', unwrap('$2')}.
address ->  '&' int            : {'address', unwrap('$2')}.
regAddress -> '&' '[' int ']' : {'address_in_register', unwrap('$3')}.



Erlang code.
unwrap({_Token, _Line, Value}) -> Value.
