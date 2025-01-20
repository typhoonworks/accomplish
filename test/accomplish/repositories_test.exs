defmodule Accomplish.RepositoriesTest do
  use Accomplish.DataCase

  alias Accomplish.Repositories

  describe "list_repositories/2" do
    setup do
      %{user: user_fixture()}
    end

    test "lists all repositories for a given user", %{user: user} do
      repository1 = repository_fixture(user, %{name: "repository1"})
      repository2 = repository_fixture(user, %{name: "repository2"})

      result = Repositories.list_repositories(user)

      assert length(result) == 2
      assert Enum.any?(result, &(&1.id == repository1.id))
      assert Enum.any?(result, &(&1.id == repository2.id))
    end

    test "returns an empty list when the user has no repositories", %{user: user} do
      assert Repositories.list_repositories(user) == []
    end
  end

  describe "get_repository/1" do
    test "returns the repository with the given ID" do
      user = user_fixture()
      repository = repository_fixture(user)

      assert Repositories.get_repository(repository.id).id == repository.id
    end

    test "returns nil if the repository does not exist" do
      assert Repositories.get_repository(UUIDv7.generate()) == nil
    end
  end

  describe "create_repository/2" do
    setup do
      %{user: user_fixture()}
    end

    test "creates a repository with valid data", %{user: user} do
      valid_attrs = %{name: "new-repository", default_branch: "main"}

      {:ok, repository} = Repositories.create_repository(user, valid_attrs)

      assert repository.name == "new-repository"
      assert repository.default_branch == "main"
      assert repository.owner_id == user.id
    end

    test "returns an error changeset with invalid data", %{user: user} do
      invalid_attrs = %{name: nil, default_branch: nil}

      {:error, changeset} = Repositories.create_repository(user, invalid_attrs)

      assert changeset.valid? == false
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).default_branch
    end

    test "returns an error changeset for invalid name format", %{user: user} do
      invalid_name = "invalid-repository-name!"
      attrs = %{name: invalid_name, default_branch: "main"}

      {:error, changeset} = Repositories.create_repository(user, attrs)

      assert changeset.valid? == false

      assert "is invalid. Only letters, numbers, and connecting underscores or hyphens are allowed." in errors_on(
               changeset
             ).name
    end

    test "returns an error changeset for duplicate name", %{user: user} do
      valid_attrs = %{name: "duplicate-repository", default_branch: "main"}

      {:ok, _repository} = Repositories.create_repository(user, valid_attrs)

      {:error, changeset} = Repositories.create_repository(user, valid_attrs)

      assert changeset.valid? == false
      assert "has already been taken" in errors_on(changeset).name
    end
  end

  describe "update_repository/2" do
    setup do
      user = user_fixture()
      repository = repository_fixture(user)
      %{user: user, repository: repository}
    end

    test "updates a repository with valid data", %{repository: repository} do
      update_attrs = %{name: "updated-repository"}

      {:ok, updated_repository} = Repositories.update_repository(repository, update_attrs)

      assert updated_repository.name == "updated-repository"
    end

    test "returns an error changeset with invalid data", %{repository: repository} do
      invalid_attrs = %{name: nil}

      {:error, changeset} = Repositories.update_repository(repository, invalid_attrs)

      assert changeset.valid? == false
      assert "can't be blank" in errors_on(changeset).name
    end

    test "returns an error changeset with invalid name format", %{repository: repository} do
      invalid_attrs = %{name: "invalid name"}

      {:error, changeset} = Repositories.update_repository(repository, invalid_attrs)

      assert changeset.valid? == false

      assert "is invalid. Only letters, numbers, and connecting underscores or hyphens are allowed." in errors_on(
               changeset
             ).name
    end

    test "returns an error changeset for duplicate name", %{user: user, repository: repository} do
      repository_fixture(user, %{name: "duplicate-repository"})
      invalid_attrs = %{name: "duplicate-repository"}

      {:error, changeset} = Repositories.update_repository(repository, invalid_attrs)

      assert changeset.valid? == false
      assert "has already been taken" in errors_on(changeset).name
    end
  end

  describe "delete_repository/1" do
    test "deletes a repository" do
      user = user_fixture()
      repository = repository_fixture(user)

      assert {:ok, _} = Repositories.delete_repository(repository)
      assert Repositories.get_repository(repository.id) == nil
    end
  end

  describe "change_repository/2" do
    test "returns a changeset" do
      user = user_fixture()
      repository = repository_fixture(user)

      changeset = Repositories.change_repository(repository, %{name: "changed-name"})

      assert changeset.valid?
      assert changeset.changes.name == "changed-name"
    end
  end
end
