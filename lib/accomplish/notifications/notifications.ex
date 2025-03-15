defmodule Accomplish.Notifications do
  @moduledoc """
  The Notifications context.
  """

  use Accomplish.Context
  alias Accomplish.Repo

  alias Accomplish.Notifications.Notification

  import AccomplishWeb.UtilityHelpers, only: [module_short_name: 1]

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications"

  def subscribe(recipient_id) do
    Phoenix.PubSub.subscribe(@pubsub, topic(recipient_id))
  end

  def unsubscribe(recipient_id) do
    Phoenix.PubSub.unsubscribe(@pubsub, topic(recipient_id))
  end

  defp topic(recipient_id), do: @notifications_topic <> ":#{recipient_id}"

  # ===========================
  # HELPERS
  # ===========================

  @system_actor_id "00000000-0000-0000-0000-000000000000"

  defp get_actor_type(%Accomplish.Accounts.User{}), do: {:ok, "User"}
  defp get_actor_type(:system), do: {:ok, "System"}
  defp get_actor_type(_), do: {:error, "Unrecognized actor type"}

  # ===========================
  # CREATING NOTIFICATIONS
  # ===========================

  def create_notification(recipient, actor, source, attrs \\ %{}) do
    case get_actor_type(actor) do
      {:ok, actor_type} ->
        actor_id = if actor == :system, do: @system_actor_id, else: actor.id

        attrs =
          Map.merge(attrs, %{
            actor_id: actor_id,
            actor_type: actor_type,
            source_id: source.id,
            source_type: module_short_name(source)
          })

        changeset = Notification.create_changeset(recipient, attrs)

        Ecto.Multi.new()
        |> Ecto.Multi.insert(:notification, changeset)
        |> Ecto.Multi.run(:update_recipient, fn repo, %{notification: _notification} ->
          actual_unread_notifications_count =
            from(n in Notification,
              where: n.type == :web,
              where: n.recipient_id == ^recipient.id,
              where: n.status == :unread,
              select: count(n.id)
            )
            |> repo.one()

          recipient
          |> Ecto.Changeset.change(unread_notifications_count: actual_unread_notifications_count)
          |> repo.update()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{notification: notification}} ->
            {:ok, notification}

          {:error, :notification, changeset, _} ->
            {:error, changeset}

          {:error, _, reason, _} ->
            {:error, reason}

          other ->
            other
        end

      {:error, reason} ->
        {:error, "Invalid actor: #{reason}"}
    end
  end

  # ===========================
  # FETCHING NOTIFICATIONS
  # ===========================

  def list_notifications(recipient, preloads \\ [], order \\ :desc) do
    query =
      from n in Notification,
        where: n.type == :web,
        where: n.recipient_id == ^recipient.id,
        order_by: [{^order, n.inserted_at}],
        preload: ^preloads

    Repo.all(query)
  end

  def list_unread_notifications(recipient, preloads \\ [], order \\ :desc) do
    query =
      from n in Notification,
        where: n.type == :web,
        where: n.recipient_id == ^recipient.id,
        where: n.status == ^:unread,
        order_by: [{^order, n.inserted_at}],
        preload: ^preloads

    Repo.all(query)
  end
end
