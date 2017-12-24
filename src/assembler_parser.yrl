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

statement -> label     : #{'label' => '$1'}.
statement -> operation : #{'operation' => '$1'}.

%%% label %%%
label -> identifer ':' : '$1'.
identifer -> atom   : unwrap('$1').

%%% operation %%%
operation -> opcode value ',' value : {'$1', {'$2', '$4'}}.
operation -> opcode value           : {'$1', '$2'}.
operation -> opcode                 : {'$1'}.

opcode -> atom : unwrap('$1').

value -> int        : {'CONST', unwrap('$1')}.
value -> regValue   : '$1'.
value -> address    : '$1'.
value -> regAddress : '$1'.

regValue ->   '[' int ']'       : {'REGISTER', unwrap('$2')}.
address ->    '&' int           : {'ADDRESS', unwrap('$2')}.
regAddress -> '&' '[' int ']'   : {'ADDRESS_IN_REGISTER', unwrap('$3')}.

Erlang code.
unwrap({_Token, _Line, Value}) -> Value.
