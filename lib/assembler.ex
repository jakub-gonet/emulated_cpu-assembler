defmodule Assembler do
require Logger
@moduledoc """
  Assembler is used to assembly .ecpu files into compiled form for
  Emulated CPU.
"""
def assembly(code, output \\[])
def assembly([], output) do
  if output === [] do
    Logger.warn(fn -> "Code seems to be empty" end)
  end
  output
end
def assembly(code, output) do
  indentifiers = save_all_identifiers(code)
  assemble_operations(code)
  replace_all_identifiers(code, indentifiers)
end

def assemble_operations(code, assembled_code \\ [])
def assemble_operations([], assembled_code) do
  assembled_code
end
def assemble_operations([%{operation: current_operation} | rest_of_code], assembled_code) do
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
def assemble_operations(rest_of_code, assembled_code) do
  assemble_operations(rest_of_code, assembled_code)
end

def replace_all_identifiers(code, indentifiers) do

end

def save_all_identifiers(code, identifiers \\ %{})
def save_all_identifiers([], identifiers) do
  identifiers
end
def save_all_identifiers([%{label: value} | rest_of_code], identifiers) do
  if Map.has_key?(identifiers, value)  do
    Logger.error(fn -> "Label redefinition" end)
    :error
  else
    identifiers = Map.put_new(identifiers, value, nil)
    save_all_identifiers(rest_of_code, identifiers)
  end
end
def save_all_identifiers([_current_expr | rest_of_code], identifiers) do
  save_all_identifiers(rest_of_code, identifiers)
end

defp split_operation_into_numbers([head | tail]) when is_atom(head) do
  import OpcodesLookupTable
  list = [head |> get_opcode |> get_opcode_number]
  split_operation_into_numbers(tail, list)
end
defp split_operation_into_numbers([head | tail], list) when is_list(head) do
  import AddressingModesLookupTable
  [addressing_mode, _] = head
  list = [addressing_mode |> get_addressing_mode_number | list]
  split_operation_into_numbers(tail, list)
end
defp split_operation_into_numbers([], list) do
  list
    |> Enum.reverse
    |> standardize_operation_numbers_list
end

defp create_opcode_number(list, base \\ 3) do
  use Bitwise
  list
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn ({item, i}) -> item <<< i*base end)
    |> Enum.reverse
    |> Enum.reduce(fn (x, acc) -> x ||| acc end)
end

defp get_args_values(args, values_list \\ [])
defp get_args_values([], values_list) do
  {:ok, values_list}
end
defp get_args_values([arg], _values_list) when is_atom(arg), do:
  arg
defp get_args_values([[:CONST | [value]] | _second], [])
when not is_atom(value) do
  {:error, :first_arg_const}
end
defp get_args_values([first | second], values_list) do
      [_addr_mode | [value | _]] = first
      values_list = values_list ++ [value]
      get_args_values(second, values_list)
end

defp standardize_operation_numbers_list(list) when is_list(list)do
  list ++ List.duplicate(0, 3-length(list))
end

defp valid_args_number?(opcode, args) do
  import OpcodesLookupTable
  req_args_number = opcode |> get_opcode |> get_required_arguments_number
  if req_args_number == length(args) do :ok
  else {:error, :bad_args_number}
  end
end

defp opcode_exists?(opcode) do
  import OpcodesLookupTable
  if get_opcode(opcode) == :error do
    {:error, :opcode_doesnt_exist}
  else :ok
  end
end

end
