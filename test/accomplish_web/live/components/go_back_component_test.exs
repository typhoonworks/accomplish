defmodule AccomplishWeb.GoBackComponentTest do
  use AccomplishWeb.ConnCase

  import Phoenix.LiveViewTest
  import Phoenix.Component, only: [assign: 2]
  alias AccomplishWeb.NavigationTracker
  alias AccomplishWeb.GoBackComponent
  alias AccomplishWeb.GoBackComponentTest.TestGoBackView

  @mock_user_id "test_user_#{:erlang.unique_integer([:positive])}"

  setup do
    NavigationTracker.record_path(@mock_user_id, "/mission_control")
    NavigationTracker.record_path(@mock_user_id, "/job_applications")

    on_exit(fn -> NavigationTracker.clear_history(@mock_user_id) end)

    user = %{id: @mock_user_id, username: "testuser"}

    %{user: user}
  end

  test "navigates to last tracked path when clicked", %{conn: conn, user: user} do
    {:ok, view, _html} = live_isolated(conn, TestGoBackView)

    view
    |> render_hook(:assign_user, %{
      user_id: user.id,
      username: user.username
    })

    view
    |> element("#test-go-back-button")
    |> render_click()

    assert_redirected(view, "/job_applications")
  end

  defmodule TestGoBackView do
    use Phoenix.LiveView

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

    def render(assigns) do
      ~H"""
      <div id="test-view" phx-hook="TestHook">
        <%= if assigns[:current_user] do %>
          <.live_component
            module={GoBackComponent}
            id="test-go-back-button"
            current_user={@current_user}
          />
        <% else %>
          <div>No user assigned yet</div>
        <% end %>
      </div>
      """
    end

    def handle_event("assign_user", %{"user_id" => id, "username" => username}, socket) do
      user = %{id: id, username: username}
      {:noreply, assign(socket, current_user: user)}
    end
  end
end
