defmodule LookupTable.AddressingModes do
@moduledoc """
Contains lookup table for addressing modes
"""

@addressing_modes %{
  CONST: 0,
  REGISTER: 1,
  ADDRESS: 2,
  ADDRESS_IN_REGISTER: 3
}


@doc """
Gets addressing mode number

Returns addressing mode number or :error
"""
def get_addressing_mode_number(addressing_mode) do
  Map.fetch!(@addressing_modes, addressing_mode)
end

end
