defmodule Assembler.Arguments do

  def get_args_values(args), do:
    _get_args_values(args, [])
  defp _get_args_values([], values_list), do: {:ok, values_list}
  defp _get_args_values([label], _values_list) when is_atom(label), do: label
  defp _get_args_values([[:CONST | [value]] | _second], [])
  when not is_atom(value), do:
    {:error, :first_arg_const}
  defp _get_args_values([first | second], values_list) when is_list(first) do
        [_addr_mode | [value | _]] = first
        values_list = values_list ++ [value]
        _get_args_values(second, values_list)
  end
  defp _get_args_values(_, _), do: {:error, :wrong_arg_type}

end
