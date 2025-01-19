defmodule AccomplishWeb.API.CLIController do
  use AccomplishWeb, :api_controller

  alias Accomplish.Accounts

  @doc """
  Initiates the CLI login by generating a CLI token and returning a browser verification URL.
  """
  def initiate_login(conn, %{"cli_version" => cli_version}) do
    context = %{"cli_version" => cli_version}

    with {:ok, raw_token} <- Accounts.generate_cli_token(context) do
      base_url = Application.get_env(:accomplish, :app_base_url, "http://localhost:4000")
      verification_url = "#{base_url}/users/log_in?cli_token=#{raw_token}"

      json(conn, %{verification_url: verification_url, token: raw_token})
    else
      {:error, changeset} ->
        errors = Helpers.serialize_validation_errors(changeset)
        Helpers.unprocessable_entity(conn, errors)
    end
  end

  def initiate_login(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "cli_version is required"})
  end
end
