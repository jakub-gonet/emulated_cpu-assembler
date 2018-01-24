defmodule Assembler.Arguments do
@moduledoc """
Assembler.Arguments is used to manipulate arguments of a single operation.
"""

  @doc """
  Given the arguments list, where each argument is [:addr_mode, value] list
  returns values in list. Returns empty list when passed no arguments.

  ## Example
  iex> args_list = [[:REGISTER, 1], [:REGISTER, 2]]
  iex> Assembler.Arguments.get_args_values(args_list)
  {:ok, [1, 2]}
  """
  def get_args_values(args, line_num), do:
    _get_args_values(args, [], line_num)
  defp _get_args_values([], values_list, _line_num), do: {:ok, values_list}
  defp _get_args_values([label], _values_list, _line_num) when is_atom(label), do: label
  defp _get_args_values([[:CONST | [value]] | _second], [], line_num)
  when not is_atom(value), do:
    {:error, :first_arg_const, value, line_num}
  defp _get_args_values([first | second], values_list, line_num) when is_list(first) do
        [_addr_mode | [value | _]] = first
        values_list = values_list ++ [value]
        _get_args_values(second, values_list, line_num)
  end

end
