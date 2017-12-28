defmodule Assembler.Opcode do

def split_operation_into_numbers(operation), do:
  _split_operation_into_numbers(operation, [])
def _split_operation_into_numbers([head | tail], list) when is_atom(head) do
  import LookupTable.Opcodes
  list = [head |> get_opcode |> get_opcode_number | list]
  _split_operation_into_numbers(tail, list)
end
def _split_operation_into_numbers([head | tail], list) when is_list(head) do
  import LookupTable.AddressingModes
  [addressing_mode, _] = head
  list = [addressing_mode |> get_addressing_mode_number | list]
  _split_operation_into_numbers(tail, list)
end
def _split_operation_into_numbers([], list) do
  list
    |> Enum.reverse
    |> standardize_operation_numbers_list
end
def _split_operation_into_numbers(_, _), do:
  {:error, :wrong_arg_type}

def create_opcode_number(list, base \\ 3)
def create_opcode_number(list, base) when length(list) == 3 do
  use Bitwise
  list
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn ({item, i}) -> item <<< i*base end)
    |> Enum.reverse
    |> Enum.reduce(fn (x, acc) -> x ||| acc end)
end
def create_opcode_number(list, _) when is_list(list), do:
  {:error, :bad_args_number}
def create_opcode_number(_, _), do:
  {:error, :wrong_arg_type}

defp standardize_operation_numbers_list(list) when is_list(list)do
  list ++ List.duplicate(0, 3-length(list))
end


def valid_args_number?(opcode, args) do
  import LookupTable.Opcodes
  req_args_number = opcode |> get_opcode |> get_required_arguments_number
  if req_args_number == length(args) do :ok
  else {:error, :bad_args_number, opcode}
  end
end

def opcode_exists?(opcode) do
  import LookupTable.Opcodes
  if get_opcode(opcode) == :error do
    {:error, :opcode_doesnt_exist, opcode}
  else :ok
  end
end

end
