defmodule AccomplishWeb.NotificationsLive do
  use AccomplishWeb, :live_view

  # alias Accomplish.Notifications

  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu

  def render(assigns) do
    ~H"""
    <.dropdown_menu>
      <.dropdown_menu_trigger id="user-notifications-trigger" class="group">
        <button type="button" class="text-zinc-400 hover:text-zinc-500 hidden lg:flex lg:items-center">
          <span class="sr-only">View notifications</span>
          <.icon class="size-5" name="hero-bell" />
        </button>
      </.dropdown_menu_trigger>
      <.dropdown_menu_content side="bottom" align="end">
        <.menu class="w-80 text-zinc-300 bg-zinc-900">
          <.menu_group class="p-4 flex items-center justify-between">
            <h3 class="text-sm">Notifications</h3>
            <button type="button" class="text-xs hover:text-purple-600 hover:underline">
              Mark all as read
            </button>
          </.menu_group>
          <.separator />
          <.menu_group id="notification-feed-wrapper" class="max-h-96 overflow-y-auto">
            <div class="flex flex-col divide-y divide-zinc-800">
              <%= for notification <- @notifications do %>
                <.notification notification={notification} />
              <% end %>
            </div>
          </.menu_group>
          <.separator />
          <.menu_group class="p-4 text-center">
            <.link href={~p"/inbox"} class="text-xs hover:underline">
              23 more unread notifications
            </.link>
          </.menu_group>
        </.menu>
      </.dropdown_menu_content>
    </.dropdown_menu>
    """
  end

  defp notification(assigns) do
    ~H"""
    <.link
      navigate={@notification.navigate_url}
      class="flex gap-3 items-center p-4 hover:bg-zinc-800 transition"
    >
      <div class="text-zinc-400 flex-none">
        <.icon name={icon_for_event_name(@notification.event_name)} class="h-5 w-5" />
      </div>
      <div class="flex flex-col flex-grow">
        <p class="text-xs text-zinc-200 font-normal">{@notification.message}</p>
        <p class="text-xs text-zinc-500 font-light mt-1">
          {formatted_relative_time(@notification.inserted_at)}
        </p>
      </div>
      <%= if @notification.status == :unread do %>
        <.unread_badge />
      <% end %>
    </.link>
    """
  end

  defp icon_for_event_name(event_name) do
    case event_name do
      "job_application.imported" -> "hero-cloud-arrow-down"
      "resume.imported" -> "hero-document-arrow-down"
      _ -> "hero-cube-transparent"
    end
  end

  on_mount {AccomplishWeb.Plugs.UserAuth, :mount_current_user}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_notifications("unread")
      |> assign_sounds()
      |> assign_play_sounds(true)

    {:ok, socket, layout: false}
  end

  def handle_info({:new_notification, notification}, socket) do
    notifications = [notification | socket.assigns.notifications]

    socket =
      socket
      |> assign(:notifications, notifications)
      |> assign(:unread_count, socket.assigns.unread_count + 1)
      |> put_flash(:info, "New notification received")
      |> maybe_play_sound()

    {:noreply, socket}
  end

  defp assign_notifications(socket, filter) do
    # user = socket.assigns.current_user

    # notifications =
    #   case filter do
    #     "all" -> Notifications.list_notifications(user)
    #     "unread" -> Notifications.list_unread_notifications(user)
    #   end

    notifications = dummy_notifications()

    assign(socket, notifications: notifications, filter: filter)
  end

  defp assign_sounds(socket) do
    json =
      JSON.encode!(%{
        pop: ~p"/audio/pop.mp3"
      })

    assign(socket, :sounds, json)
  end

  defp assign_play_sounds(socket, play_sounds) do
    assign(socket, play_sounds: play_sounds)
  end

  defp maybe_play_sound(socket) do
    play_sounds = socket.assigns.play_sounds

    case play_sounds do
      true -> push_event(socket, "play-sound", %{name: "pop"})
      _ -> socket
    end
  end

  def dummy_notifications do
    [
      %{
        id: 1,
        event_name: "job_application.imported",
        message: "Application to Senior Software Engineer at Stripe imported.",
        navigate_url: "#",
        inserted_at: Timex.shift(Timex.now(), minutes: -41),
        status: :unread
      },
      %{
        id: 2,
        event_name: :message,
        message: "You have a new message in #Dota2-tournament by Nikita Alexeevich",
        navigate_url: "#",
        inserted_at: Timex.shift(Timex.now(), minutes: -41),
        status: :unread
      },
      %{
        id: 3,
        event_name: "resume.imported",
        message: "Your resume was successfully imported.",
        navigate_url: "#",
        inserted_at: Timex.shift(Timex.now(), minutes: -41),
        status: :unread
      },
      %{
        id: 4,
        event_name: :update,
        message: "Your app is ready to install a new update (v3.12). Refresh the page",
        navigate_url: "#",
        inserted_at: Timex.shift(Timex.now(), minutes: -41),
        status: :unread
      }
    ]
  end
end
