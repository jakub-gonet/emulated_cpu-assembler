defmodule Assembler.Opcode do

def split_operation_into_numbers([head | tail]) when is_atom(head) do
  import OpcodesLookupTable
  list = [head |> get_opcode |> get_opcode_number]
  split_operation_into_numbers(tail, list)
end
def split_operation_into_numbers([head | tail], list) when is_list(head) do
  import AddressingModesLookupTable
  [addressing_mode, _] = head
  list = [addressing_mode |> get_addressing_mode_number | list]
  split_operation_into_numbers(tail, list)
end
def split_operation_into_numbers([], list) do
  list
    |> Enum.reverse
    |> standardize_operation_numbers_list
end

def create_opcode_number(list, base \\ 3) do
  use Bitwise
  list
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn ({item, i}) -> item <<< i*base end)
    |> Enum.reverse
    |> Enum.reduce(fn (x, acc) -> x ||| acc end)
end


def standardize_operation_numbers_list(list) when is_list(list)do
  list ++ List.duplicate(0, 3-length(list))
end


def valid_args_number?(opcode, args) do
  import OpcodesLookupTable
  req_args_number = opcode |> get_opcode |> get_required_arguments_number
  if req_args_number == length(args) do :ok
  else {:error, :bad_args_number}
  end
end

def opcode_exists?(opcode) do
  import OpcodesLookupTable
  if get_opcode(opcode) == :error do
    {:error, :opcode_doesnt_exist}
  else :ok
  end
end

end
