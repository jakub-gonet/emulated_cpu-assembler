defmodule AssemblerLexerTest do
  use ExUnit.Case, async: true
  import Parser, only: [tokenize: 1]

test "tokenize/1 - valid syntax is passed" do
  assert tokenize("MOV &[1], 2") ==  {:ok, [{:atom, 1, :MOV},
           {:&, 1}, {:"[", 1}, {:int, 1, 1}, {:"]", 1},
           {:",", 1}, {:int, 1, 2}], 1}
end

test "tokenize/1 - valid syntax is passed, but lowercase" do #should treat it as identifier
  assert tokenize("mov 2, 2") == {:ok, [{:string, 1, 'mov'}, {:int, 1, 2}, {:",", 1}, {:int, 1, 2}], 1}
end

test "tokenize/1 - valid 1 arg opcode is used" do
  assert tokenize("JMP loop") == {:ok, [{:atom, 1, :JMP}, {:string, 1, 'loop'}], 1}
end

end
