defmodule AssemblerParserTest do
  use ExUnit.Case, async: true
  import Parser, only: [parse: 1]

test "parse/1" do
  tokenized = [{:atom, 1, :loop}, {:":", 1}, {:atom, 2, :MOV}, {:"[", 2}, {:int, 2, 2},
  {:"]", 2}, {:",", 2}, {:"[", 2}, {:int, 2, 1}, {:"]", 2}, {:atom, 3, :JMP},
  {:atom, 3, :loop}]

  expected = {:ok, [%{label: :loop},
              %{operation: [:MOV, [:REGISTER, 2], [:REGISTER, 1]]},
              %{operation: [:JMP, [:CONST, :loop]]}]}


  assert parse(tokenized) == expected
end
test "parse/1 - parenthesis doesn't match" do
  tokenized = [{:atom, 1, :MOV}, {:"[", 1}, {:int, 1, 13}, {:",", 1}, {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)

  tokenized = [{:atom, 1, :MOV}, {:int, 1, 13}, {:"[", 1},  {:",", 1}, {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)
end

test "parse/1 - too much arguments" do
  tokenized = [{:atom, 1, :MOV}, {:"[", 1}, {:int, 1, 13}, {:"]", 1}, {:",", 1},
  {:int, 1, 8}, {:",", 1}, {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)

  tokenized = [{:atom, 1, :MOV}, {:"[", 1}, {:int, 1, 13}, {:"]", 1}, {:",", 1},
  {:int, 1, 8}, {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)
end

test "parse/1 - comma is missing" do
  tokenized = [{:atom, 1, :MOV}, {:"[", 1}, {:int, 1, 13}, {:"]", 1}, {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)
end

test "parse/1 - number / label isn't used as value" do
  tokenized = [{:atom, 1, :MOV}, {:"[", 1}, {:atom, 1, :k}, {:"]", 1}, {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)

  tokenized = [{:atom, 1, :MOV}, {:atom, 1, :test}, {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)

  tokenized = [{:atom, 1, :MOV}, {:"[", 1}, {:":", 1}, {:atom, 1, :hello}, {:"]", 1},
  {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)
end

test "wrong symbol is used" do
  tokenized =  [{:atom, 1, :MOV}, {:atom, 1, :"$"}, {:"[", 1}, {:int, 1, 2}, {:"]", 1},
  {:",", 1}, {:int, 1, 8}]
  assert {:error, _} = parse(tokenized)
end

end
