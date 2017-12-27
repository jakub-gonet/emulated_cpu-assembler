defmodule AssemblerTest do
  use ExUnit.Case
  import Assembler, only: [assemble: 1]
  import ExUnit.CaptureLog
  require Logger

Logger.remove_backend(:console)

test "assembled code returned if passed correctly parsed code" do
  parsed_code = [%{operation: [:MOV, [:REGISTER, 1], [:CONST, 2]]}, %{label: :loop},
                 %{operation: [:JMP, [:CONST, :loop]]}]

  assert assemble(parsed_code) == [0x88, 1, 2, 0xc0, 3]
end

test "empty list returned if passed empty code" do
  assert assemble([]) == []
  assert capture_log(fn -> assemble([]) end) =~ "Code seems to be empty"
end

test "error returned when passed label without reference in code" do
  parsed_code = [%{operation: [:JMP, [:CONST, :error]]}]

  assert {:error, :label_non_existent, _} = assemble(parsed_code)
end

test "error returned when multiple label" do
  parsed_code = [%{label: :hi}, %{label: :hi}]
  assert {:error, :redefined_label, _} = assemble(parsed_code)
end

end
