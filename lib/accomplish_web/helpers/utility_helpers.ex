defmodule AccomplishWeb.UtilityHelpers do
  @moduledoc false

  def module_short_name(module) when is_atom(module) do
    if Code.ensure_loaded?(module) do
      module
      |> Module.split()
      |> tl()
      |> Enum.join(".")
    else
      {:error, :not_a_loaded_module}
    end
  end

  def module_from_short_name(short_name) when is_binary(short_name) do
    Module.concat([Accomplish | String.split(short_name, ".")])
  end
end
