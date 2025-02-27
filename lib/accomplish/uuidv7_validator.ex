defmodule Accomplish.UUIDv7Validator do
  @moduledoc false

  @doc """
  Validates if the given value is a valid UUIDv7 string or binary.
  """
  @spec valid_uuid?(any()) :: boolean()
  def valid_uuid?(value) when is_binary(value) do
    case UUIDv7.cast(value) do
      {:ok, _} -> true
      :error -> false
    end
  end

  def valid_uuid?(_), do: false
end
