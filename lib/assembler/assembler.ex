defmodule Assembler do
require Logger
import Assembler.Arguments
import Assembler.Opcode
import Assembler.Labels
@moduledoc """
  Assembler is used to assembly .ecpu files into compiled form for
  Emulated CPU.
"""

def assemble([]) do
    Logger.warn(fn -> "Code seems to be empty" end)
end
def assemble(code) when is_list(code) do
  assembled_with_labels = assemble_operations(code)
  save_all_labels(assembled_with_labels)
    |> replace_all_labels(assembled_with_labels)
    |> remove_all_labels()
end

defp assemble_operations(code, assembled_code \\ [])
defp assemble_operations([], assembled_code) do
  assembled_code
end
defp assemble_operations([%{label: value} | rest_of_code], assembled_code) do
  assemble_operations(rest_of_code, assembled_code ++ [%{label: value}])
end
defp assemble_operations([%{operation: current_operation} | rest_of_code], assembled_code) do
  [opcode | args] = current_operation
  with :ok <- opcode_exists?(opcode),
       :ok <- valid_args_number?(opcode, args),
       opcode_addr_modes_number = current_operation
                                   |> split_operation_into_numbers
                                   |> create_opcode_number,
       {:ok, args_values} <- get_args_values(args)
    do
      assemble_operations(rest_of_code, assembled_code ++ [opcode_addr_modes_number | args_values])
    else
      {:error, :bad_args_number} -> Logger.error(fn -> "Wrong arguments number for opcode #{opcode}" end)
      {:error, :opcode_doesnt_exist} -> Logger.error(fn -> "Opcode #{opcode} doesn't exist" end)
      {:error, :first_arg_const} -> Logger.error(fn -> "First argument cannot be const value" end)
    end
end
defp assemble_operations(rest_of_code, assembled_code) do
  assemble_operations(rest_of_code, assembled_code)
end

end
