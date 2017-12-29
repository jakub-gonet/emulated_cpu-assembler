Nonterminals
  statements
  statement
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
  string
  '['
  ']'
  ','
  ':'
  '&'.

Rootsymbol statements.

statements -> statement                 : ['$1'].
statements -> statement statements      : ['$1' | '$2'].

statement -> label     : #{'label' => '$1'}.
statement -> operation : #{'operation' => '$1'}.

%%% label %%%
label -> identifer ':' : '$1'.
identifer -> string    : unwrap_string('$1').

%%% operation %%%
operation -> opcode value ',' value : ['$1', '$2', '$4'].
operation -> opcode value           : ['$1', '$2'].
operation -> opcode identifer       : ['$1', ['CONST', '$2']].
operation -> opcode                 : ['$1'].

opcode -> atom : unwrap('$1').

value -> int        : ['CONST', unwrap('$1')].
value -> regValue   : '$1'.
value -> address    : '$1'.
value -> regAddress : '$1'.

regValue ->   '[' int ']'       : ['REGISTER', unwrap('$2')].
address ->    '&' int           : ['ADDRESS', unwrap('$2')].
regAddress -> '&' '[' int ']'   : ['ADDRESS_IN_REGISTER', unwrap('$3')].

Erlang code.
unwrap_string({_Token, _Line, Value}) -> list_to_atom(Value).
unwrap({_Token, _Line, Value}) -> Value.
