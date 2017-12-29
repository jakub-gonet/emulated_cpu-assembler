Nonterminals
code statement operation value.

Terminals
label identifer integer ',' opcode register address address_in_register.

Rootsymbol code.

code -> statement      : ['$1'].
code -> statement code : ['$1' | '$2'].

statement -> label     : #{'label' => label('$1')}.
statement -> operation : #{'operation' => '$1'}.

operation -> opcode value ',' value : [operation('$1'), '$2', '$4'].
operation -> opcode value           : [operation('$1'), '$2'].
operation -> opcode identifer       : [operation('$1'), value('$2')].
operation -> opcode                 : [operation('$1')].

value -> integer  : value('$1').
value -> register : value('$1').
value -> address  : value('$1').
value -> address_in_register : value('$1').

Erlang code.

operation({opcode, _, OpcodeName})     -> OpcodeName.

label({label, _, Value})               -> Value.

value({identifer, _, Value})           -> ['CONST', Value];
value({integer, _, Value})             -> ['CONST', Value];
value({register, _, Value})            -> ['REGISTER', Value];
value({address, _, Value})             -> ['ADDRESS', Value];
value({address_in_register, _, Value}) -> ['ADDRESS_IN_REGISTER', Value].
