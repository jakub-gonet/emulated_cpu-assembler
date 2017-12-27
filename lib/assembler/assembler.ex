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
    []
end
def assemble(code) when is_list(code) do
  if contains_HLT?(code) do
    Logger.warn(fn -> "Code doesn't contain HLT opcode" end)
  end

  with {:ok, assembled} <- assemble_operations(code),
       {:ok, labels} <- save_all_labels(assembled),
       {:ok, without_labels_def} <- remove_all_labels_def(assembled),
       {:ok, output} <- replace_all_labels(labels, without_labels_def)
    do
      output
    else
      {:error, :label_non_existent, label} ->
        Logger.error(fn -> "Label #{label} doesn't exist" end)
        {:error, :label_non_existent, label}
      {:error, :redefined_label, label} ->
        Logger.error(fn -> "Label #{label} redefinition" end)
        {:error, :redefined_label, label}
      {:error, :bad_args_number, opcode} ->
        Logger.error(fn -> "Wrong arguments number for opcode #{opcode}" end)
        {:error, :bad_args_number}
      {:error, :opcode_doesnt_exist, opcode} ->
        Logger.error(fn -> "Opcode #{opcode} doesn't exist" end)
        {:error, :opcode_doesnt_exist}
      {:error, :first_arg_const} ->
        Logger.error(fn -> "First argument cannot be const value" end)
        {:error, :first_arg_const}
    end
end

defp assemble_operations(code, assembled_code \\ [])
defp assemble_operations([], assembled_code) do
  {:ok, assembled_code}
end
defp assemble_operations([%{label: value} | rest_of_code], assembled_code) do
  assemble_operations(rest_of_code, assembled_code ++ [%{label: value}])
end
defp assemble_operations([%{operation: current_expr} | rest_of_code], assembled_code) do
  [opcode | args] = current_expr
  with :ok <- opcode_exists?(opcode),
       :ok <- valid_args_number?(opcode, args),
       opcode_addr_modes_number = current_expr
                                   |> split_operation_into_numbers
                                   |> create_opcode_number,
       {:ok, args_values} <- get_args_values(args)
    do
      assemble_operations(rest_of_code, assembled_code ++ [opcode_addr_modes_number | args_values])
  end
end
defp assemble_operations(rest_of_code, assembled_code) do
  assemble_operations(rest_of_code, assembled_code)
end

defp contains_HLT?([]), do:
  {:warning, :isnt_halted}
defp contains_HLT?([%{operation: [:HLT | _]} | _rest_of_code]), do:
  :ok
defp contains_HLT?([_current_expr | rest_of_code]), do:
  contains_HLT?(rest_of_code)
end
