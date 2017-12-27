defmodule Assembler.Arguments do

  def get_args_values(args, values_list \\ [])
  def get_args_values([], values_list) do
    {:ok, values_list}
  end
  def get_args_values([arg], _values_list) when is_atom(arg), do:
    arg
  def get_args_values([[:CONST | [value]] | _second], [])
  when not is_atom(value) do
    {:error, :first_arg_const}
  end
  def get_args_values([first | second], values_list) do
        [_addr_mode | [value | _]] = first
        values_list = values_list ++ [value]
        get_args_values(second, values_list)
  end

end
