defmodule Assembler.Labels do
require Logger
@moduledoc """
Assembler.Labels is used to handle any operation connected with labels.
"""

  @doc """
  Given code and labels replaces all accurences of particular label.
  """
  def replace_all_labels(labels, code), do:
    _replace_all_labels(labels, code, [])
  defp _replace_all_labels(_labels, [], output), do:
     {:ok, Enum.reverse(output)}
  defp _replace_all_labels(labels, [label | rest_of_code], output) when is_atom(label) do
    if not Map.has_key?(labels, label) do
      {:error, :label_non_existent, label}
    else
    _replace_all_labels(labels, rest_of_code, [Map.fetch!(labels, label) | output])
    end
  end
  defp _replace_all_labels(labels, [current_expr | rest_of_code], output), do:
    _replace_all_labels(labels, rest_of_code, [current_expr | output])

  @doc """
  Given code removes all occurences of labels definitions.

  ## Example
  iex> code = [%{label: :loop}, %{operation: [:JMP, [:CONST, :loop]]}, %{label: :label}]
  iex> Assembler.Labels.remove_all_labels_def(code)
  {:ok, [%{operation: [:JMP, [:CONST, :loop]]}]}
  """
  def remove_all_labels_def(code), do:
    _remove_all_labels_def(code, [])
  defp _remove_all_labels_def([], output), do:
    {:ok, Enum.reverse(output)}
  defp _remove_all_labels_def([%{label: _label} | rest_of_code], output), do:
    _remove_all_labels_def(rest_of_code, output)
  defp _remove_all_labels_def([current_expr | rest_of_code], output), do:
    _remove_all_labels_def(rest_of_code, [current_expr | output])

  @doc """
  Given code searchs for any label and saves it. Returns map with labels.
  """
  def save_all_labels(code), do:
    _save_all_labels(code, %{}, 0)
  defp _save_all_labels([], labels, _expr_number), do:
    {:ok, labels}
  defp _save_all_labels([%{label: {line_num, label}} | rest_of_code], labels, expr_number) do
    if Map.has_key?(labels, label)  do
      {:error, :redefined_label, label, line_num}
    else
      labels = Map.put_new(labels, label, expr_number)
      _save_all_labels(rest_of_code, labels, expr_number)
    end
  end
  defp _save_all_labels([_current_expr | rest_of_code], labels, expr_number), do:
    _save_all_labels(rest_of_code, labels, expr_number+1)

end
