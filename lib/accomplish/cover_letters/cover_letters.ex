defmodule Accomplish.CoverLetters do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.JobApplications.Application
  alias Accomplish.CoverLetters.CoverLetter
  alias Accomplish.CoverLetters.Events

  import Accomplish.Utils.Maps, only: [atomize_keys: 1]

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"
  @events_topic "events:all"

  def get_application_cover_letter!(application, id, opts \\ []) do
    preloads = Keyword.get(opts, :preloads, [])
    with_deleted = Keyword.get(opts, :with_deleted, false)

    query =
      from(cl in CoverLetter,
        where: cl.id == ^id and cl.application_id == ^application.id
      )

    result = Repo.one!(query, with_deleted: with_deleted)
    Repo.preload(result, preloads)
  end

  def get_cover_letter!(id, opts \\ []) do
    preloads = Keyword.get(opts, :preloads, [])
    with_deleted = Keyword.get(opts, :with_deleted, false)

    CoverLetter
    |> Repo.get!(id, with_deleted: with_deleted)
    |> Repo.preload(preloads)
  end

  def list_cover_letters_for_application(application_id, preloads \\ []) do
    query =
      from c in CoverLetter,
        where: c.application_id == ^application_id,
        order_by: [desc: c.inserted_at],
        preload: ^preloads

    Repo.all(query)
  end

  def create_cover_letter(%Application{} = application, attrs \\ %{}) do
    attrs = atomize_keys(attrs)
    changeset = CoverLetter.create_changeset(application, attrs)

    case Repo.insert(changeset) do
      {:ok, cover_letter} ->
        broadcast_cover_letter_created(cover_letter, application)
        {:ok, cover_letter}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_cover_letter(%CoverLetter{} = cover_letter, attrs) do
    attrs = atomize_keys(attrs)
    changeset = CoverLetter.update_changeset(cover_letter, attrs)

    case Repo.update(changeset) do
      {:ok, updated_cover_letter} ->
        application = Repo.get!(Application, updated_cover_letter.application_id)
        broadcast_cover_letter_updated(updated_cover_letter, application)
        {:ok, updated_cover_letter}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a cover letter with content from a streaming source.

  This function is optimized for frequent updates during streaming:
  - Uses a database transaction with row locking to prevent conflicts
  - Only updates if the cover letter is still in draft status
  - Does not broadcast events to reduce overhead during streaming

  ## Parameters
    - cover_letter: The cover letter to update
    - content: The new content to set

  ## Returns
    - {:ok, updated_cover_letter} on success
    - {:error, reason} on failure
  """
  # def update_streaming_content(cover_letter, content) do
  #   try do
  #     result =
  #       Repo.transaction(fn ->
  #         locked_letter =
  #           CoverLetter
  #           |> where(id: ^cover_letter.id)
  #           |> lock("FOR UPDATE")
  #           |> Repo.one!()

  #         if locked_letter.status == :draft do
  #           changeset = CoverLetter.update_changeset(locked_letter, %{content: content})
  #           Repo.update!(changeset)
  #         else
  #           locked_letter
  #         end
  #       end)

  #     case result do
  #       {:ok, updated_letter} -> {:ok, updated_letter}
  #       {:error, error} -> {:error, error}
  #     end
  #   rescue
  #     e ->
  #       {:error, :database_error}
  #   end
  # end
  def update_streaming_content(cover_letter, content) do
    try do
      case Repo.get(CoverLetter, cover_letter.id) do
        nil ->
          {:error, :not_found}

        letter ->
          if letter.status == :draft do
            changeset = CoverLetter.update_changeset(letter, %{content: content})
            Repo.update(changeset)
          else
            {:ok, letter}
          end
      end
    rescue
      e ->
        Logger.error("Error updating streaming content: #{inspect(e)}")
        {:error, :database_error}
    end
  end

  def submit_cover_letter(%CoverLetter{} = cover_letter) do
    changeset =
      cover_letter
      |> Ecto.Changeset.change(
        status: :submitted,
        submitted_at: DateTime.utc_now() |> DateTime.truncate(:second)
      )

    case Repo.update(changeset) do
      {:ok, updated_cover_letter} ->
        application = Repo.get!(Application, updated_cover_letter.application_id)
        broadcast_cover_letter_submitted(updated_cover_letter, application)
        {:ok, updated_cover_letter}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_cover_letter(application, id) do
    with %CoverLetter{} = cover_letter <- get_application_cover_letter!(application, id),
         {:ok, _} <-
           Repo.transaction(fn ->
             Repo.delete!(cover_letter)
             broadcast_cover_letter_deleted(cover_letter, application)
           end) do
      {:ok, cover_letter}
    else
      nil -> {:error, :not_found}
      {:error, e} -> {:error, e}
      _ -> {:error, :unexpected_error}
    end
  end

  def change_cover_letter(%CoverLetter{} = cover_letter, attrs \\ %{}) do
    CoverLetter.changeset(cover_letter, attrs)
  end

  defp broadcast_cover_letter_created(cover_letter, application) do
    broadcast!(
      %Events.NewCoverLetter{
        cover_letter: cover_letter,
        application: application
      },
      application.applicant_id
    )
  end

  defp broadcast_cover_letter_updated(cover_letter, application) do
    broadcast!(
      %Events.CoverLetterUpdated{
        cover_letter: cover_letter,
        application: application
      },
      application.applicant_id
    )
  end

  defp broadcast_cover_letter_submitted(cover_letter, application) do
    broadcast!(
      %Events.CoverLetterSubmitted{
        cover_letter: cover_letter,
        application: application
      },
      application.applicant_id
    )
  end

  defp broadcast_cover_letter_deleted(cover_letter, application) do
    broadcast!(
      %Events.CoverLetterDeleted{
        cover_letter: cover_letter,
        application: application
      },
      application.applicant_id
    )
  end

  defp broadcast!(msg, user_id) do
    Phoenix.PubSub.broadcast!(@pubsub, @notifications_topic <> ":#{user_id}", {__MODULE__, msg})
    Phoenix.PubSub.broadcast!(@pubsub, @events_topic, {__MODULE__, msg})
  end
end
