defmodule Accomplish.Validators do
  @moduledoc """
  Provides reusable validation functions for schemas.
  """

  import Ecto.Changeset

  @doc """
  Validates that a field contains a valid URL.

  ## Options

    * `:message` - Custom error message to use (default varies based on validation error).
    * `:strict` - If `true`, checks if the host resolves via DNS. Defaults to `true`.

  ## Examples

      iex> changeset = validate_url(changeset, :website)
      %Ecto.Changeset{}

      iex> changeset = validate_url(changeset, :website, strict: false)
      %Ecto.Changeset{}
  """
  def validate_url(changeset, field, opts \\ []) do
    strict = Keyword.get(opts, :strict, true)

    validate_change(changeset, field, fn _, value ->
      value
      |> parse_url()
      |> validate_parsed_url(field, opts, strict)
    end)
  end

  defp parse_url(value) do
    case URI.parse(value) do
      %URI{scheme: nil} -> {:error, "is missing a scheme (e.g. https)"}
      %URI{host: nil} -> {:error, "is missing a host"}
      %URI{host: host} -> {:ok, host}
    end
  end

  defp validate_parsed_url({:ok, _host}, _field, _opts, false), do: []

  defp validate_parsed_url({:ok, host}, field, _opts, true) do
    case :inet.gethostbyname(Kernel.to_charlist(host)) do
      {:ok, _} -> []
      {:error, _} -> [{field, "invalid host"}]
    end
  end

  defp validate_parsed_url({:error, error}, field, opts, _strict) do
    [{field, Keyword.get(opts, :message, error)}]
  end
end
