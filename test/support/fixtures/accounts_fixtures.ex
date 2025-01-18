defmodule Accomplish.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.Accounts` context.
  """

  def unique_username, do: "user#{System.unique_integer()}"
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      username: unique_username(),
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accomplish.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  def valid_api_key_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: "Test API Key",
      scopes: ["repo:read", "repo:write"]
    })
  end

  def api_key_fixture(user, attrs \\ %{}) do
    attrs = attrs |> valid_api_key_attributes()

    {:ok, api_key} = Accomplish.Accounts.create_api_key(user, attrs)

    api_key
  end
end
