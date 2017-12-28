defmodule AssemblerParserTest do
  use ExUnit.Case, async: true
  import Parser, only: [parse: 1]

test "parse/1" do
  expected = [%{label: :loop},
              %{operation: [:MOV, [:REGISTER, 2], [:REGISTER, 1]]},
              %{operation: [:JMP, [:CONST, :loop]]}]
  assert parse("loop:\nMOV [2], [1]\nJMP loop\n") == expected
end
test "parse/1 - parenthesis doesn't match" do
  assert_raise(MatchError, fn -> parse("MOV [13, 8") end)
  assert_raise(MatchError, fn -> parse("MOV 13], 8") end)
end

test "parse/1 - too much arguments" do
  assert_raise(MatchError, fn -> parse("MOV [13], 8, 8") end)
  assert_raise(MatchError, fn -> parse("MOV [13], 8 8") end)
end

test "parse/1 - added \\n inside operation" do
  assert_raise(MatchError, fn -> parse("MOV [1\n3], 8") end)
  assert_raise(MatchError, fn -> parse("MOV [1\n3], 8") end)
  assert parse("MOV [13],\n 8") == [%{operation: [:MOV, [:REGISTER, 13], [:CONST, 8]]}]
end

test "parse/1 - comma is missing" do
  assert_raise(MatchError, fn -> parse("MOV [13] 8") end)
end

test "parse/1 - number / label isn't used as value" do
  assert_raise(MatchError, fn -> parse("MOV [k], 8") end)
  assert_raise(MatchError, fn -> parse("MOV test, 8") end)
  assert_raise(MatchError, fn -> parse("MOV [:hello], 8") end)
end

test "wrong symbol is used" do
  assert_raise(MatchError, fn -> parse("MOV $[2], 8") end)
  assert_raise(MatchError, fn -> parse("MOV (2), 8") end)
end

end
