defmodule AssemblerLexerTest do
  use ExUnit.Case
  import Parser, only: [tokenize: 1]

test "tokenized form returned when valid syntax is passed" do
  assert tokenize("MOV &[1], 2") ==  [{:atom, 1, :MOV},
           {:&, 1}, {:"[", 1}, {:int, 1, 1}, {:"]", 1},
           {:",", 1}, {:int, 1, 2}]
end

test "opcode recognized as atom when valid syntax is passed, but lowercase" do
  assert tokenize("mov 2, 2") == [{:atom, 1, :mov}, {:int, 1, 2}, {:",", 1}, {:int, 1, 2}]
end

test "tokenized form returned when valid 1 arg opcode is used" do
assert tokenize("JMP loop") == [{:atom, 1, :JMP}, {:atom, 1, :loop}]
end

test "error raised when used wrong assigment operator" do
  assert_raise(MatchError, fn -> tokenize("K@ba = 13")  end)
end

end
