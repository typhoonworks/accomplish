defmodule Accomplish.Scopes do
  @moduledoc """
  Defines and validates accepted scopes for OAuth.
  """

  import Ecto.Changeset

  @scopes ~w(
    read:user
    write:user
    read:repository
    write:repository
  )

  @doc """
  Validates that a field contains only accepted scopes.

  ## Options
    * `:message` - Custom error message for invalid scopes (default: "contains invalid scopes").

  ## Examples

      iex> changeset = validate_scopes(changeset, :scopes)
      %Ecto.Changeset{}

      iex> changeset = validate_scopes(changeset, :scopes)
      %Ecto.Changeset{errors: [scopes: "contains invalid scopes"]}
  """
  def validate_scopes(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, scopes ->
      invalid_scopes = Enum.filter(scopes, &(&1 not in @scopes))

      if invalid_scopes == [] do
        []
      else
        [{field, Keyword.get(opts, :message, "contains invalid scopes")}]
      end
    end)
  end
end
