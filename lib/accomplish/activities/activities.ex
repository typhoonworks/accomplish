defmodule Accomplish.Activities do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.Activities.Activity

  @target_modules %{
    "JobApplications.Application" => Accomplish.JobApplications.Application,
    "Accounts.User" => Accomplish.Accounts.User
  }

  @target_names %{
    Accomplish.JobApplications.Application => "JobApplications.Application",
    Accomplish.Accounts.User => "Accounts.User"
  }

  def fetch_target(target_id, target_type) do
    case Map.get(@target_modules, target_type) do
      nil ->
        {:error, "Unknown target type: #{target_type}"}

      module ->
        case Repo.get(module, target_id) do
          nil -> {:error, "Target not found (#{target_type}, ID: #{target_id})"}
          target -> {:ok, target}
        end
    end
  end

  def get_target_type(target) do
    Map.get(@target_names, target.__struct__, "Unknown")
  end

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
end
