Definitions.

Whitespace = \s+
Terminator = \n|\r\n|\r
Identifier = [a-zA-Z0-9#@!?%$^_-]+
Comment = #.+
LeftBracket = {
RightBracket = }

Digit = [0-9]
NonZeroDigit = [1-9]
Sign = [\+\-]

OpCode = [A-Z]+
Value = (0|{Sign}?{NonZeroDigit}{Digit}*)

Rules.

{Whitespace}        : skip_token.
{Terminator}        : skip_token.
{Comment}           : skip_token.
{LeftBracket}       : {token, {'{',  TokenLine}}.
{RightBracket}      : {token, {'}',  TokenLine}}.
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
