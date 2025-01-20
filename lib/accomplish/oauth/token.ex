defmodule Accomplish.OAuth.Token do
  @moduledoc """
  Utilities for generating secure OAuth tokens.
  """

  @alphabet Enum.concat([?0..?9, ?A..?Z])

  @doc """
  Generates a secure, URL-safe token with the specified length.
  Used for access tokens and other secure purposes.

  ## Examples

      iex> Accomplish.OAuth.Token.generate(32)
      "randomlygeneratedsecuretoken..."
  """
  def generate(length \\ 32) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64(padding: false)
    |> String.slice(0, length)
  end

  @doc """
  Generates a secure refresh token.

  By default, uses the same format as the regular token.

  ## Examples

      iex> Accomplish.OAuth.Token.generate_refresh_token()
      "secure_refresh_token..."
  """
  def generate_refresh_token do
    generate()
  end

  @doc """
  Generates a user-friendly `user_code` for the Device Authorization Flow.

  The code consists of uppercase alphanumeric characters for readability.

  ## Examples

      iex> Accomplish.OAuth.Token.generate_user_code()
      "AB12CD34"
  """
  def generate_user_code(length \\ 8) do
    Stream.repeatedly(&random_char_from_alphabet/0)
    |> Enum.take(length)
    |> List.to_string()
  end

  defp random_char_from_alphabet() do
    Enum.random(@alphabet)
  end
end
