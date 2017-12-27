defmodule AssemblerParserTest do
  use ExUnit.Case
  import Parser, only: [parse: 1]

test "parsed form returned when passed valid argument" do
  assert parse("loop:\nMOV [2], [1]\nJMP loop\n") == [%{label: :loop},
                                                             %{operation: [:MOV, [:REGISTER, 2], [:REGISTER, 1]]},
                                                             %{operation: [:JMP, [:CONST, :loop]]}]
end
test "error raised when parenthesis doesn't match" do
  assert_raise(MatchError, fn -> parse("MOV [13, 8") end)
end

test "parsed form returned when added \\n inside operation" do
  assert parse("MOV [13],\n 8") == [%{operation: [:MOV, [:REGISTER, 13], [:CONST, 8]]}]
end

test "error raised when comma is missing" do
  assert_raise(MatchError, fn -> parse("MOV [13] 8") end)
end

test "error raised when letter is used as value" do
  assert_raise(MatchError, fn -> parse("MOV [k], 8") end)
end

test "error raised when wrong symbol is used" do
  assert_raise(MatchError, fn -> parse("MOV $[2], 8") end)
end

end
