defmodule AccomplishWeb.Plugs.AuthorizePublicAPI do
  @moduledoc """
  A passthrough plug for authorizing requests with either an API key (Basic Auth)
  or OAuth token (Bearer Auth). It will try to authenticate using OAuth first,
  and if that fails, it will fall back to API key authentication.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    case get_oauth_token(conn) do
      {:ok, _token} ->
        # If OAuth token is present, validate it
        AccomplishWeb.Plugs.AuthorizeOAuthToken.call(conn, opts)

      {:error, _reason} ->
        # If no OAuth token, fallback to API key authentication
        AccomplishWeb.Plugs.AuthorizeAPIKey.call(conn, opts)
    end
  end

  defp get_oauth_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> {:error, :missing_token}
    end
  end
end
