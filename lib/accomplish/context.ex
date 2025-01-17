defmodule Accomplish.Context do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      alias Ecto.Multi
      alias Accomplish.Repo
    end
  end
end
