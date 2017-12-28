defmodule LookupTable.AddressingModesTest do
  use ExUnit.Case, async: true
  import LookupTable.AddressingModes

test "get_addressing_mode_number/1" do
  assert get_addressing_mode_number(:CONST) == 0
  assert get_addressing_mode_number(:REGISTER) == 1

  assert_raise(KeyError, fn -> get_addressing_mode_number(:A) end)
  assert_raise(KeyError, fn -> get_addressing_mode_number(CONST) end)
  assert_raise(KeyError, fn -> get_addressing_mode_number([]) end)
end
end
