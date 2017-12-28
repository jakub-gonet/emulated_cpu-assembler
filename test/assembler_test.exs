defmodule AssemblerTest do
  use ExUnit.Case, async: true
  import Assembler, only: [assemble: 1]
  import ExUnit.CaptureLog
  require Logger
  @moduletag :capture_log

test "assemble/1 - passed correctly parsed code" do
  parsed_code = [%{operation: [:MOV, [:REGISTER, 1], [:CONST, 2]]}, %{label: :loop},
                 %{operation: [:JMP, [:CONST, :loop]]}]
  assert assemble(parsed_code) == {:ok, [0x88, 1, 2, 0xc0, 3]}
end

test "assemble/1 - passed empty code" do
  assert assemble([]) == []
  assert capture_log(fn -> assemble([]) end) =~ "Code seems to be empty"
end

test "assemble/1 - label without reference in code" do
  parsed_code = [%{operation: [:JMP, [:CONST, :error]]}]


  assert capture_log(fn -> assemble(parsed_code) end) =~ "Label error doesn't exist"
end

test "assemble/1 - multiple label definition" do
  parsed_code = [%{label: :hi}, %{label: :hi}]
  assert capture_log(fn -> assemble(parsed_code) end) =~ "Label hi redefinition"
end

test "assemble/1 - too little arguments in operation" do
  parsed_code = [%{operation: [:MOV, [:REGISTER, 1]]}]
  assert capture_log(fn -> assemble(parsed_code) end) =~ "Wrong arguments number for opcode MOV"
  parsed_code = [%{operation: [:JMP, [:REGISTER, 1], [:REGISTER, 1]]}]
  assert capture_log(fn -> assemble(parsed_code) end) =~ "Wrong arguments number for opcode JMP"
  parsed_code = [%{operation: [:MOV]}]
  assert capture_log(fn -> assemble(parsed_code) end) =~ "Wrong arguments number for opcode MOV"
end

end
