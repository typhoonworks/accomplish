defmodule Accomplish.Profiles.Importer do
  @moduledoc """
  Service for importing profile data into user profiles.

  This module centralizes profile import logic within the Profiles context
  and emits events when a profile is successfully imported.
  """

  import Ecto.Query

  alias Accomplish.Profiles
  alias Accomplish.Profiles.Events.ProfileImported
  alias Accomplish.Repo

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

  @doc """
  Imports profile data for a user, updating their profile, experiences, and education entries.
  Emits a `ProfileImported` event on successful import.

  ## Parameters
    - user: The user whose profile will be updated
    - profile_data: A map containing "profile", "experiences", and "education" data

  ## Returns
    - `{:ok, %{profile: profile, experiences: experiences, educations: educations}}` on success
    - `{:error, reason}` on failure
  """
  def import_profile_data(user, profile_data) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:profile, fn _repo, _changes ->
      profile_attrs = Map.get(profile_data, "profile", %{})
      profile_params = atomize_profile_params(profile_attrs)

      Profiles.upsert_profile(user, profile_params)
    end)
    |> Ecto.Multi.run(:experiences, fn _repo, %{profile: profile} ->
      process_experiences(profile, Map.get(profile_data, "experiences", []))
    end)
    |> Ecto.Multi.run(:education, fn _repo, %{profile: profile} ->
      process_education(profile, Map.get(profile_data, "education", []))
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{profile: profile, experiences: experiences, education: educations}} ->
        broadcast_profile_imported(profile, experiences, educations)
        {:ok, %{profile: profile, experiences: experiences, educations: educations}}

      {:error, step, changeset, _changes} ->
        {:error, {:import_failed, step, changeset}}
    end
  end

  defp atomize_profile_params(profile_attrs) do
    profile_attrs
    |> Enum.map(fn {k, v} ->
      key = String.to_existing_atom(k)
      {key, v}
    end)
    |> Map.new()
  end

  defp process_experiences(profile, experiences) do
    if experiences != [] do
      from(e in Profiles.Experience, where: e.profile_id == ^profile.id)
      |> Repo.delete_all()
    end

    results =
      Enum.map(experiences, fn exp ->
        experience_params = atomize_experience_params(exp)
        result = Profiles.add_experience(profile, experience_params)

        case result do
          {:error, _changeset} ->
            result

          ok ->
            ok
        end
      end)

    errors =
      Enum.filter(results, fn
        {:error, _} -> true
        _ -> false
      end)

    if errors != [] do
      _first_error = hd(errors)
      {:error, :failed_to_import_experiences}
    else
      {:ok, Enum.map(results, fn {:ok, exp} -> exp end)}
    end
  end

  defp atomize_experience_params(experience) do
    base_params =
      experience
      |> Enum.map(fn {k, v} ->
        key = String.to_existing_atom(k)
        {key, v}
      end)
      |> Map.new()

    base_params
    |> Map.put(:start_date, parse_date_string(base_params[:start_date]))
    |> Map.put(:end_date, parse_date_string(base_params[:end_date]))
  end

  defp process_education(profile, education_entries) do
    if education_entries != [] do
      from(edu in Profiles.Education, where: edu.profile_id == ^profile.id)
      |> Repo.delete_all()
    end

    results =
      Enum.map(education_entries, fn edu ->
        education_params = atomize_education_params(edu)
        Profiles.add_education(profile, education_params)
      end)

    if Enum.any?(results, fn
         {:error, _} -> true
         _ -> false
       end) do
      {:error, :failed_to_import_education}
    else
      {:ok, Enum.map(results, fn {:ok, edu} -> edu end)}
    end
  end

  defp atomize_education_params(education) do
    base_params =
      education
      |> Enum.map(fn {k, v} ->
        key = String.to_existing_atom(k)
        {key, v}
      end)
      |> Map.new()

    base_params
    |> Map.put(:start_date, parse_date_string(base_params[:start_date]))
    |> Map.put(:end_date, parse_date_string(base_params[:end_date]))
  end

  defp parse_date_string(nil), do: nil

  defp parse_date_string(date_string) when is_binary(date_string) do
    case String.split(date_string, "-") do
      [year, month] ->
        try do
          year_int = String.to_integer(year)
          month_int = String.to_integer(month)

          if year_int > 0 && month_int >= 1 && month_int <= 12 do
            Date.new!(year_int, month_int, 1)
          else
            nil
          end
        rescue
          _ -> nil
        end

      _ ->
        nil
    end
  rescue
    _ -> nil
  end

  defp parse_date_string(_), do: nil

  defp broadcast_profile_imported(profile, experiences, educations) do
    Phoenix.PubSub.broadcast!(
      @pubsub,
      @notifications_topic <> ":#{profile.user_id}",
      {Profiles,
       %ProfileImported{
         profile: profile,
         experiences: experiences,
         educations: educations
       }}
    )
  end
end
