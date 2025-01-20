defmodule Accomplish.OAuth.Token do
  @moduledoc """
  Utilities for generating secure OAuth tokens.
  """

  @token_length 32

  @doc """
  Generates a secure token with a fixed length.

  ## Examples

      iex> Accomplish.OAuth.Token.generate()
      "randomlygeneratedsecuretoken..."

  """
  def generate(length \\ @token_length) do
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
end
