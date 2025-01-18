defmodule Accomplish.Repositories.Repository do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Accounts.User

  @permitted ~w(name default_branch git_url ssh_url clone_url)a
  @required ~w(name default_branch)a

  @name_pattern ~r/^(?!-)[a-zA-Z0-9_-]+(?<!-)$/

  @derive {JSON.Encoder,
           only: [
             :id,
             :name,
             :default_branch,
             :git_url,
             :ssh_url,
             :clone_url,
             :inserted_at,
             :updated_at
           ]}

  schema "repositories" do
    field :name, :string
    field :default_branch, :string
    field :git_url, :string
    field :ssh_url, :string
    field :clone_url, :string

    belongs_to :owner, User, foreign_key: :owner_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, @permitted)
    |> common_validations()
  end

  @doc false
  def create_changeset(owner, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> put_assoc(:owner, owner)
  end

  @doc false
  def update_changeset(repository, attrs) do
    repository |> changeset(attrs)
  end

  defp common_validations(changeset) do
    changeset
    |> validate_required(@required)
    |> validate_name_format()
    |> unsafe_validate_unique(:name, Accomplish.Repo)
    |> unique_constraint(:name)
  end

  def validate_name_format(changeset) do
    validate_format(changeset, :name, @name_pattern,
      message:
        "is invalid. Only letters, numbers, and connecting underscores or hyphens are allowed."
    )
  end
end
