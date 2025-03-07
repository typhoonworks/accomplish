defmodule Accomplish.ConfigHelpers do
  @type config_type :: :str | :int | :bool | :json

  @doc """
  Get value from an environment variable, converting it to the given type.

  If no default is given, it raises an error if the variable is missing.
  """
  @spec get_env(String.t(), any() | :no_default, config_type()) :: any()
  def get_env(var, default \\ :no_default, type \\ :str)

  def get_env(var, :no_default, type) do
    System.fetch_env!(var)
    |> convert_type(type)
  end

  def get_env(var, default, type) do
    with {:ok, val} <- System.fetch_env(var) do
      convert_type(val, type)
    else
      :error -> default
    end
  end

  defp convert_type(val, :str), do: val
  defp convert_type(val, :int), do: String.to_integer(val)
  defp convert_type("true", :bool), do: true
  defp convert_type("false", :bool), do: false
  defp convert_type(val, :json), do: JSON.decode!(val)
  defp convert_type(val, type), do: raise("Cannot convert #{inspect(val)} to #{inspect(type)}")
end
