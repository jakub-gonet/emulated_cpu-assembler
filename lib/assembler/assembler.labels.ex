defmodule Assembler.Labels do

require Logger

def replace_all_labels(labels, code), do:
  _replace_all_labels(labels, code, [])
defp _replace_all_labels(_labels, [], output), do:
  Enum.reverse(output)
defp _replace_all_labels(labels, [label | rest_of_code], output) when is_atom(label) do
  if not Map.has_key?(labels, label)  do
    Logger.error(fn -> "Label #{label} doesn't exist" end)
    :error
  else
  _replace_all_labels(labels, rest_of_code, [Map.fetch!(labels, label) | output])
  end
end
defp _replace_all_labels(labels, [current_expr | rest_of_code], output), do:
  _replace_all_labels(labels, rest_of_code, [current_expr | output])

def remove_all_labels(code), do:
  _remove_all_labels(code, [])
defp _remove_all_labels([], output), do:
  Enum.reverse(output)
defp _remove_all_labels([%{label: _label} | rest_of_code], output), do:
  _remove_all_labels(rest_of_code, output)
defp _remove_all_labels([current_expr | rest_of_code], output), do:
  _remove_all_labels(rest_of_code, [current_expr | output])

def save_all_labels(code), do:
  _save_all_labels(code, %{}, 0)
defp _save_all_labels([], labels, _expr_number), do:
  labels
defp _save_all_labels([%{label: label} | rest_of_code], labels, expr_number) do
  if Map.has_key?(labels, label)  do
    Logger.error(fn -> "Label redefinition" end)
    :error
  else
    labels = Map.put_new(labels, label, expr_number)
    _save_all_labels(rest_of_code, labels, expr_number)
  end
end
defp _save_all_labels([_current_expr | rest_of_code], labels, expr_number), do:
  _save_all_labels(rest_of_code, labels, expr_number+1)

end
