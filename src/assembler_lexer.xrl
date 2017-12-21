Definitions.

Whitespace = \s+
Terminator = \n|\r\n|\r
Identifier = [a-zA-Z0-9#@!?%$^_-]+

Digit = [0-9]
NonZeroDigit = [1-9]
Sign = [\+\-]

OpCode = [A-Za-z]+
Value = (0|{Sign}?{NonZeroDigit}{Digit}*)
Label = {Identifier}:

Rules.

{Whitespace}        : skip_token.
{Terminator}        : {token, {'\n',  TokenLine}}.
,                   : {token, {',',  TokenLine}}.
\&                  : {token, {'&',  TokenLine}}.
\[                  : {token, {'[',  TokenLine}}.
\]                  : {token, {']',  TokenLine}}.
{Value}             : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
<=                  : {token, {'<=', TokenLine}}.
\:                  : {token, {':',  TokenLine}}.
{OpCode}            : {token, {atom, TokenLine, list_to_atom(TokenChars)}}.
{Identifier}        : {token, {atom, TokenLine, list_to_atom(TokenChars)}}.

Erlang code.
