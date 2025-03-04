defmodule AccomplishWeb.NavigationHookTest do
  use AccomplishWeb.ConnCase

  import Phoenix.LiveViewTest
  import Phoenix.Component, only: [assign: 2]
  alias AccomplishWeb.NavigationTracker
  alias AccomplishWeb.NavigationHookTest.TestTrackedLiveView

  @mock_user_id "test_user_#{:erlang.unique_integer([:positive])}"

  setup do
    on_exit(fn -> NavigationTracker.clear_history(@mock_user_id) end)

    user = %{id: @mock_user_id, username: "testuser"}
    session = %{"user_token" => "mock_token"}

    %{user: user, session: session}
  end

  test "navigation hook records path", %{conn: conn, user: user, session: session} do
    {:ok, view, _html} = live_isolated(conn, TestTrackedLiveView, session: session)

    view
    |> render_hook(:assign_values, %{
      user_id: user.id,
      username: user.username,
      current_path: "/test_path"
    })

    view |> render_hook(:execute_navigation_hook)

    Process.sleep(100)

    assert "/test_path" in NavigationTracker.get_history(user.id)
  end

  defmodule TestTrackedLiveView do
    use Phoenix.LiveView

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

    def render(assigns) do
      ~H"""
      <div id="test-view" phx-hook="TestHook">Test LiveView</div>
      """
    end

    def handle_event(
          "assign_values",
          %{"user_id" => id, "username" => username, "current_path" => path},
          socket
        ) do
      user = %{id: id, username: username}
      {:noreply, assign(socket, current_user: user, current_path: path)}
    end

    def handle_event("execute_navigation_hook", _params, socket) do
      if socket.assigns[:current_user] && socket.assigns[:current_path] do
        NavigationTracker.record_path(socket.assigns.current_user.id, socket.assigns.current_path)
      end

      {:noreply, socket}
    end
  end
end
