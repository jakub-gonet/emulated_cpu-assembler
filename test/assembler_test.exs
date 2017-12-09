defmodule AssemblerTest do
  use ExUnit.Case
  doctest Assembler

  test "greets the world" do
    assert Assembler.hello() == :world
  end
end
