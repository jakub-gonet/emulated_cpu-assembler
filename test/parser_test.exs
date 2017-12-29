defmodule AssemblerParserTest do
  use ExUnit.Case, async: true
  import Parser, only: [parse: 1]

test "parse/1" do
  {:ok, tokenized, _} = Parser.tokenize("loop:\nMOV [2], [1]\nJMP loop")

  expected = {:ok, [%{label: :loop},
              %{operation: [:MOV, [:REGISTER, 2], [:REGISTER, 1]]},
              %{operation: [:JMP, [:CONST, :loop]]}]}


  assert parse(tokenized) == expected
end
test "parse/1 - parenthesis doesn't match" do
  {:ok, tokenized, _} = Parser.tokenize("MOV [1, 8")
  assert {:error, _} = parse(tokenized)

  {:ok, tokenized, _} = Parser.tokenize("MOV 13], 8")
  assert {:error, _} = parse(tokenized)
end

test "parse/1 - too much arguments" do
  {:ok, tokenized, _} = Parser.tokenize("MOV [13], 8, 4")
  assert {:error, _} = parse(tokenized)

  {:ok, tokenized, _} = Parser.tokenize("MOV [13], 8 4")
  assert {:error, _} = parse(tokenized)
end

test "parse/1 - comma is missing" do
  {:ok, tokenized, _} = Parser.tokenize("MOV [13] 4")
  assert {:error, _} = parse(tokenized)
end

test "parse/1 - number / label isn't used as value" do
  {:ok, tokenized, _} = Parser.tokenize("MOV [k], 8")
  assert {:error, _} = parse(tokenized)

  {:ok, tokenized, _} = Parser.tokenize("MOV test:, 8")
  assert {:error, _} = parse(tokenized)

  {:ok, tokenized, _} = Parser.tokenize("MOV hello, 8")
  assert {:error, _} = parse(tokenized)
end

test "wrong symbol is used" do
    {:ok, tokenized, _} = Parser.tokenize("MOV $[2], 8")
  assert {:error, _} = parse(tokenized)
end

end
