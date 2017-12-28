defmodule Assembler.Opcode do
@moduledoc """
Assembler.Opcode is used to perform operations on operation' opcode.
"""

  @doc """
  Given operation, in form [:OPCODE, [:addr_mode_1, value1], [:addr_mode_2, value2]],
  returns list of numbers corresponding to opcode and addressing modes.
  """
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

  @doc """
  Given list of opcode and arguments addressing mode numbers merges it into one number
  by bitwise ORing it with given offset. Note: list should be normalized.

  ## Example
  iex> Assembler.Opcode.create_opcode_number([1,2,1])
  81
  """
  def create_opcode_number(list, offset \\ 3)
  def create_opcode_number(list, offset) when length(list) == 3 do
    use Bitwise
    list
      |> Enum.reverse
      |> Enum.with_index
      |> Enum.map(fn ({item, i}) -> item <<< i*offset end)
      |> Enum.reverse
      |> Enum.reduce(fn (x, acc) -> x ||| acc end)
  end

  defp standardize_operation_numbers_list(list) when is_list(list)do
    list ++ List.duplicate(0, 3-length(list))
  end

  @doc """
  Given opcode and arguments returns :ok if number of arguments matches opcode's
  required arguments number, {:error, :bad_args_number, opcode_name} otherwise.
  """
  def valid_args_number?(opcode, args) do
    import LookupTable.Opcodes
    req_args_number = opcode |> get_opcode |> get_required_arguments_number
    if req_args_number == length(args) do :ok
    else {:error, :bad_args_number, opcode}
    end
  end

  @doc """
  Checks if given opcode exists.
  """
  def opcode_exists?(opcode) do
    import LookupTable.Opcodes
    if get_opcode(opcode) == :error do
      {:error, :opcode_doesnt_exist, opcode}
    else :ok
    end
  end

end
