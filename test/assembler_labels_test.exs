defmodule Assembler.LabelsTest do
  use ExUnit.Case, async: true
  import Assembler.Labels

test "replace_all_labels/2" do
  assert replace_all_labels(%{hi: 12}, [2,3,:hi]) == {:ok, [2,3,12]}
  assert replace_all_labels(%{hi: 12}, []) == {:ok, []}
end

test "remove_all_labels_def/1" do
  assert remove_all_labels_def([%{label: :label}]) == {:ok, []}
end

test "save_all_labels/1" do
  assert save_all_labels([%{label: :label}, 12, %{label: :next}]) == {:ok, %{label: 0, next: 1}}
end

end
