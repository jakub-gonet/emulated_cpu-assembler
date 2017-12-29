Definitions.

Whitespace = \s+
Terminator = \n|\r\n|\r
Comment = #.+

Identifier = [a-zA-Z0-9#@!?%$^_-]+
Label = {Identifier}:

Digit = [0-9]
NonZeroDigit = [1-9]
Sign = [\+\-]
Value = (0|{Sign}?{NonZeroDigit}{Digit}*)

Register = \[{Value}\]
Address = \&{Value}
AddressInRegister = \&\[{Value}\]
OpCode = [A-Z]+


Rules.

{Whitespace}        : skip_token.
{Terminator}        : skip_token.
{Comment}           : skip_token.
,                   : {token, {',',  TokenLine}}.
{Value}             : {token, {integer, TokenLine, list_to_integer(TokenChars)}}.
{Register}          : {token, {register, TokenLine, matched_values_to_integer(TokenChars)}}.
{Address}           : {token, {address, TokenLine, matched_values_to_integer(TokenChars)}}.
{AddressInRegister} : {token, {address_in_register, TokenLine, matched_values_to_integer(TokenChars)}}.
{OpCode}            : {token, {opcode, TokenLine, list_to_atom(TokenChars)}}.
{Label}             : {token, {label, TokenLine, label_to_atom(TokenChars)}}.
{Identifier}        : {token, {identifer, TokenLine, list_to_atom(TokenChars)}}.

Erlang code.

matched_values_to_integer(Str) ->
list_to_integer(
  lists:flatten(
    string:tokens(Str, "&[]")
  )
).

label_to_atom(Label) ->
list_to_atom(
  lists:flatten(
    string:tokens(Label, ":")
  )
).
