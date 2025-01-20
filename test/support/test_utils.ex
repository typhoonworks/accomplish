defmodule Accomplish.TestUtils do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      require Accomplish.TestUtils
      import Accomplish.TestUtils
    end
  end
end
