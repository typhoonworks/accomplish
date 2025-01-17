defmodule Accomplish.Schema do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      @primary_key {:id, UUIDv7, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts type: :utc_datetime_usec

      import Ecto
      import Ecto.Changeset

      alias Ecto.Multi
    end
  end
end
