defmodule Accomplish.Validators do
  @moduledoc """
  Provides reusable validation functions for schemas.
  """

  import Ecto.Changeset

  @doc """
  Validates that a field contains a valid URL.

  ## Options

    * `:message` - Custom error message to use (default varies based on validation error).

  ## Examples

      iex> changeset = validate_url(changeset, :redirect_uri)
      %Ecto.Changeset{}

      iex> changeset = validate_url(changeset, :invalid_field)
      %Ecto.Changeset{errors: [redirect_uri: "is missing a scheme (e.g. https)"]}
  """
  def validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      value
      |> parse_url()
      |> validate_parsed_url(field, opts)
    end)
  end

  defp parse_url(value) do
    case URI.parse(value) do
      %URI{scheme: nil} -> {:error, "is missing a scheme (e.g. https)"}
      %URI{host: nil} -> {:error, "is missing a host"}
      %URI{host: host} -> validate_host(host)
    end
  end

  defp validate_host(host) do
    case :inet.gethostbyname(Kernel.to_charlist(host)) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, "invalid host"}
    end
  end

  defp validate_parsed_url(:ok, _field, _opts), do: []

  defp validate_parsed_url({:error, error}, field, opts) do
    [{field, Keyword.get(opts, :message, error)}]
  end
end
