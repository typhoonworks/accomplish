defmodule Accomplish.Activities do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.Activities.Activity

  def log_activity(actor, action, target, metadata \\ %{}) do
    case get_actor_type(actor) do
      {:ok, actor_type} ->
        %Activity{}
        |> Activity.changeset(%{
          actor_id: actor.id,
          actor_type: actor_type,
          action: action,
          metadata: metadata,
          target_id: target.id,
          target_type: get_target_type(target)
        })
        |> Repo.insert()

      {:error, reason} ->
        {:error, "Invalid actor: #{reason}"}
    end
  end

  defp get_actor_type(%Accomplish.Accounts.User{}), do: {:ok, "User"}
  defp get_actor_type(_), do: {:error, "Unrecognized actor type"}

  defp get_target_type(target) do
    target.__struct__
    |> Module.split()
    |> drop_accomplish_prefix()
    |> Enum.join(".")
  end

  defp drop_accomplish_prefix(["Accomplish" | rest]), do: rest
  defp drop_accomplish_prefix(modules), do: modules
end
