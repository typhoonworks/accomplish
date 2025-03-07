defmodule Accomplish.URLValidators do
  @moduledoc """
  Provides reusable validation functions for schemas.
  """

  import Ecto.Changeset

  @doc """
  Validates a URL string directly, outside of a changeset context.

  Returns :ok if valid, or {:error, reason} if invalid.

  ## Options

    * `:strict` - If `true`, checks if the host resolves via DNS. Defaults to `true`.

  ## Examples

      iex> validate_url_string("https://example.com")
      :ok

      iex> validate_url_string("missing-scheme.com")
      {:error, "URL is missing a scheme (e.g. https)"}
  """
  def validate_url_string(url, opts \\ []) do
    strict = Keyword.get(opts, :strict, true)

    case parse_url(url) do
      {:ok, host} -> validate_host(host, strict)
      {:error, reason} -> {:error, "URL #{reason}"}
    end
  end

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

  defp validate_host(host, true) do
    case :inet.gethostbyname(Kernel.to_charlist(host)) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, "Invalid host: unable to resolve domain"}
    end
  end

  defp validate_host(_host, false), do: :ok

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
