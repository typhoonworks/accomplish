defmodule Accomplish.Schema do
  @moduledoc false

  @doc """
  When used, this module:

  1. Imports Ecto and Ecto.Changeset
  2. Sets up UUIDv7 primary keys
  3. Sets binary_id foreign keys
  4. Sets UTC datetime timestamps with microseconds
  """
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      @primary_key {:id, UUIDv7, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts type: :utc_datetime_usec

      import Ecto
      import Ecto.Changeset

      alias Ecto.Multi
      alias Accomplish.URLValidators
    end
  end
end
