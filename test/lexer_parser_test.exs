defmodule AssemblerParserTest do
  use ExUnit.Case

test "Tokenized form returned when valid syntax is passed" do
  assert Parser.tokenize("MOV &[1], 2") ==  [{:atom, 1, :MOV},
           {:&, 1}, {:"[", 1}, {:int, 1, 1}, {:"]", 1},
           {:",", 1}, {:int, 1, 2}]
end

test "Opcode recognized as atom when valid syntax is passed, but lowercase" do
  assert Parser.tokenize("mov 2, 2") == [{:atom, 1, :mov}, {:int, 1, 2}, {:",", 1}, {:int, 1, 2}]
end

test "Tokenized form returned when valid 1 arg opcode is used" do
assert Parser.tokenize("JMP loop") == [{:atom, 1, :JMP}, {:atom, 1, :loop}]
end

test "Error raised when used wrong assigment operator" do
  assert_raise(MatchError, fn -> Parser.tokenize("K@ba = 13")  end)
end

########Parser#########

test "Parsed form returned when passed valid argument" do
  assert Parser.parse("MOV [2], [1]\np2a <= [13]") == [operation: {:MOV, {:register, 2}, {:register, 1}},
                                                       assigment: {:p2a, {:register, 13}}]
end

test "Error raised when parenthesis doesn't match" do
  assert_raise(MatchError, fn -> Parser.parse("MOV [13, 8") end)
end

test "Error raised when comma is missing" do
  assert_raise(MatchError, fn -> Parser.parse("MOV [13] 8") end)
end

test "Error raised when letter is used as value" do
  assert_raise(MatchError, fn -> Parser.parse("MOV [k], 8") end)
end

test "Error raised when wrong symbol is used" do
  assert_raise(MatchError, fn -> Parser.parse("MOV $[2], 8") end)
end
end
