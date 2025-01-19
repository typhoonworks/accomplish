defmodule Accomplish.OAuthTest do
  use Accomplish.DataCase

  alias Accomplish.OAuth
  alias Accomplish.OAuth.Identity

  @invalid_attrs %{
    uid: nil,
    provider: nil,
    access_token: nil,
    refresh_token: nil,
    expires_at: nil,
    scopes: nil
  }

  describe "oauth_identities" do
    test "list_oauth_identities/1 returns all oauth identities for a user" do
      user = user_fixture()
      oauth_identity = oauth_identity_fixture(%{user: user})

      assert OAuth.list_oauth_identities(user) == [oauth_identity]
    end

    test "get_oauth_identity/2 returns the oauth identity by provider and UID" do
      oauth_identity = oauth_identity_fixture()

      assert OAuth.get_oauth_identity(oauth_identity.provider, oauth_identity.uid) ==
               oauth_identity
    end

    test "get_oauth_identity_for_user/3 returns the oauth identity for a specific user" do
      user = user_fixture()
      other_user = user_fixture()
      oauth_identity = oauth_identity_fixture(%{user: user})

      assert OAuth.get_oauth_identity_for_user(
               user.id,
               oauth_identity.provider,
               oauth_identity.uid
             ) ==
               oauth_identity

      assert OAuth.get_oauth_identity_for_user(
               other_user.id,
               oauth_identity.provider,
               oauth_identity.uid
             ) ==
               nil
    end

    test "create_oauth_identity/1 with valid data creates an oauth identity" do
      user = user_fixture()

      valid_attrs = %{
        uid: "some uid",
        provider: "github",
        access_token: "some access_token",
        refresh_token: "some refresh_token",
        expires_at: ~U[2025-01-18 13:18:00Z],
        scopes: ["option1", "option2"],
        user_id: user.id
      }

      assert {:ok, %Identity{} = oauth_identity} = OAuth.create_oauth_identity(valid_attrs)
      assert oauth_identity.uid == "some uid"
      assert oauth_identity.provider == "github"
      assert oauth_identity.access_token == "some access_token"
      assert oauth_identity.refresh_token == "some refresh_token"
      assert oauth_identity.expires_at == ~U[2025-01-18 13:18:00Z]
      assert oauth_identity.scopes == ["option1", "option2"]
      assert oauth_identity.user_id == user.id
    end

    test "create_oauth_identity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OAuth.create_oauth_identity(@invalid_attrs)
    end

    test "update_oauth_identity/2 with valid data updates the oauth identity" do
      oauth_identity = oauth_identity_fixture()

      update_attrs = %{
        uid: "some updated uid",
        access_token: "some updated access_token",
        refresh_token: "some updated refresh_token",
        expires_at: ~U[2025-01-19 13:18:00Z],
        scopes: ["option1"]
      }

      assert {:ok, %Identity{} = oauth_identity} =
               OAuth.update_oauth_identity(oauth_identity, update_attrs)

      assert oauth_identity.uid == "some updated uid"
      assert oauth_identity.access_token == "some updated access_token"
      assert oauth_identity.refresh_token == "some updated refresh_token"
      assert oauth_identity.expires_at == ~U[2025-01-19 13:18:00Z]
      assert oauth_identity.scopes == ["option1"]
    end

    test "update_oauth_identity/2 with invalid data returns error changeset" do
      oauth_identity = oauth_identity_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OAuth.update_oauth_identity(oauth_identity, @invalid_attrs)

      assert oauth_identity ==
               OAuth.get_oauth_identity(oauth_identity.provider, oauth_identity.uid)
    end

    test "delete_oauth_identity/1 deletes the oauth identity" do
      oauth_identity = oauth_identity_fixture()
      assert {:ok, %Identity{}} = OAuth.delete_oauth_identity(oauth_identity)

      assert OAuth.get_oauth_identity(oauth_identity.provider, oauth_identity.uid) == nil
    end

    test "change_oauth_identity/1 returns an oauth identity changeset" do
      oauth_identity = oauth_identity_fixture()
      assert %Ecto.Changeset{} = OAuth.change_oauth_identity(oauth_identity)
    end

    test "link_identity_to_user/2 links an identity to a user" do
      user = user_fixture()
      oauth_identity = oauth_identity_fixture()

      assert {:ok, %Identity{} = updated_identity} =
               OAuth.link_identity_to_user(oauth_identity, user.id)

      assert updated_identity.user_id == user.id
    end
  end
end
