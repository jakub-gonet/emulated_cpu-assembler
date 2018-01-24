defmodule Assembler do
require Logger
import Assembler.Arguments
import Assembler.Opcode
import Assembler.Labels
@moduledoc """
  Assembler is used to assembly .ecpu files into compiled form for
  Emulated CPU.
"""

  @doc """
  Given the parsed code, assembles it and returns list.
  Warns when code not contain HLT opcode or is empty and logs errors when passed wrong code.

  ## Example
    MOV [1], [2]

    iex> code = [%{operation: [:MOV, [:REGISTER, 1], [:REGISTER, 2]]}]
    iex> Assembler.assemble(code)
    [warn]  Code doesn't contain HLT opcode
    {:ok, [137, 1, 2]}

  ##
    CMP [1]

    iex> code = [%{operation: [:CMP, [:REGISTER, 1]]}]
    iex> Assembler.assemble(code)

    [warn]  Code doesn't contain HLT opcode
    {:error, :bad_args_number}

    [error] Wrong arguments number for opcode CMP

  ##
    iex> Assembler.assemble([])
    [warn]  Code seems to be empty
    []
  """
  def assemble([]) do
      Logger.warn(fn -> "Code seems to be empty" end)
      []
  end
  def assemble(code) when is_list(code) do
    if not contains_HLT?(code) do
      Logger.warn(fn -> "Code doesn't contain HLT opcode" end)
    end

    with {:ok, assembled} <- assemble_operations(code),
         {:ok, labels} <- save_all_labels(assembled),
         {:ok, without_labels_def} <- remove_all_labels_def(assembled),
         {:ok, output} <- replace_all_labels(labels, without_labels_def)
      do
        {:ok, output}
      else
        {:error, :label_non_existent, label} ->
          Logger.error(fn -> "Label #{label} doesn't exist" end)
        {:error, :redefined_label, label, line_num} ->
          Logger.error(fn -> "##{line_num} Label #{label} redefinition" end)
        {:error, :bad_args_number, opcode, line_num} ->
          Logger.error(fn -> "##{line_num} Wrong arguments number for opcode #{opcode}" end)
        {:error, :opcode_doesnt_exist, opcode, line_num} ->
          Logger.error(fn -> "##{line_num} Opcode #{opcode} doesn't exist" end)
        {:error, :first_arg_const, value, line_num} ->
          Logger.error(fn -> "##{line_num} First argument value (#{value}) cannot be const" end)
      end
  end

  defp assemble_operations(code), do:
    _assemble_operations(code, [])
  defp _assemble_operations([], assembled_code), do:
    {:ok, assembled_code}
  defp _assemble_operations([%{label: {line_num, value}} | rest_of_code], assembled_code), do:
    _assemble_operations(rest_of_code, assembled_code ++ [%{label: {line_num, value}}])
  defp _assemble_operations([%{operation: {line_num, current_expr}} | rest_of_code], assembled_code) do
    [opcode | args] = current_expr
    with :ok <- opcode_exists?(opcode, line_num),
         :ok <- valid_args_number?(opcode, args, line_num),
         opcode_addr_modes_number = current_expr
                                     |> split_operation_into_numbers
                                     |> create_opcode_number,
         {:ok, args_values} <- get_args_values(args, line_num)
      do
        _assemble_operations(rest_of_code, assembled_code ++ [opcode_addr_modes_number | args_values])
    end
  end
  defp _assemble_operations(rest_of_code, assembled_code), do:
    _assemble_operations(rest_of_code, assembled_code)

  defp contains_HLT?([]), do:
    false
  defp contains_HLT?([%{operation: {_, [:HLT | _]}} | _rest_of_code]), do:
    true
  defp contains_HLT?([_current_expr | rest_of_code]), do:
    contains_HLT?(rest_of_code)

end
