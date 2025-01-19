defmodule Accomplish.Accounts.OAuthServiceTest do
  use Accomplish.DataCase, async: true

  alias Accomplish.Accounts.OAuthService
  alias Accomplish.OAuth

  @valid_auth %{
    user: %{
      "sub" => "12345",
      "email" => "user@example.com",
      "login" => "john_doe"
    },
    token: %{
      "access_token" => "abcd1234",
      "refresh_token" => "refresh1234",
      "scope" => "read:user,user:email"
    }
  }

  describe "find_or_create_user_from_oauth/2" do
    test "creates a new user and links OAuth identity when no user exists" do
      assert {:ok, user} = OAuthService.find_or_create_user_from_oauth("github", @valid_auth)

      assert user.email == "user@example.com"
      assert user.username == "john-doe"

      identity = OAuth.get_oauth_identity("github", "12345")
      assert identity.provider == "github"
      assert identity.uid == "12345"
      assert identity.user_id == user.id
    end

    test "links OAuth identity to an existing user" do
      existing_user = user_fixture(%{email: "user@example.com", username: "existing-user"})

      assert {:ok, user} = OAuthService.find_or_create_user_from_oauth("github", @valid_auth)
      assert user.id == existing_user.id

      identity = OAuth.get_oauth_identity("github", "12345")
      assert identity.provider == "github"
      assert identity.uid == "12345"
      assert identity.user_id == existing_user.id
    end

    test "returns an error when OAuth identity creation fails" do
      assert {:error, _reason} =
               OAuthService.find_or_create_user_from_oauth("invalid_provider", @valid_auth)

      refute Repo.get_by(Accomplish.Accounts.User, email: "user@example.com")
    end
  end
end
