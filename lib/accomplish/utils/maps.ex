defmodule Accomplish.Utils.Maps do
  @moduledoc false

  @doc """
  Converts map keys from strings to atoms, ensuring existing atoms are used.
  """
  def atomize_keys(%{__struct__: _} = struct), do: struct

  def atomize_keys(%{} = map) do
    map
    |> Enum.map(fn {k, v} ->
      key = if is_binary(k), do: String.to_existing_atom(k), else: k
      {key, atomize_value(v)}
    end)
    |> Enum.into(%{})
  end

  def atomize_keys(non_map), do: non_map

  defp atomize_value(value) when is_map(value), do: atomize_keys(value)

  defp atomize_value(value) when is_list(value) do
    Enum.map(value, fn
      item when is_map(item) -> atomize_keys(item)
      other -> other
    end)
  end

  defp atomize_value(value), do: value
end
