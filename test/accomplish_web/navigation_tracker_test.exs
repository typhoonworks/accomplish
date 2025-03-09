defmodule AccomplishWeb.NavigationTrackerTest do
  use ExUnit.Case

  alias AccomplishWeb.NavigationTracker

  @mock_user_id "test_user_#{:erlang.unique_integer([:positive])}"
  @max_history_size 10

  setup do
    on_exit(fn -> NavigationTracker.clear_history(@mock_user_id) end)

    :ok
  end

  describe "record_path/2" do
    test "records a path in user history" do
      NavigationTracker.record_path(@mock_user_id, "/test")

      assert NavigationTracker.get_history(@mock_user_id) == ["/test"]
    end

    test "adds new paths at the beginning of history" do
      NavigationTracker.record_path(@mock_user_id, "/first")
      NavigationTracker.record_path(@mock_user_id, "/second")

      assert NavigationTracker.get_history(@mock_user_id) == ["/second", "/first"]
    end

    test "removes duplicates when recording paths" do
      NavigationTracker.record_path(@mock_user_id, "/test")
      NavigationTracker.record_path(@mock_user_id, "/other")
      NavigationTracker.record_path(@mock_user_id, "/test")

      assert NavigationTracker.get_history(@mock_user_id) == ["/test", "/other"]
    end

    test "limits history to #{@max_history_size} items" do
      Enum.each(1..(@max_history_size + 5), fn i ->
        NavigationTracker.record_path(@mock_user_id, "/path#{i}")
      end)

      history = NavigationTracker.get_history(@mock_user_id)
      assert length(history) == @max_history_size

      assert Enum.at(history, 0) == "/path#{@max_history_size + 5}"
    end
  end

  describe "get_last_path/1" do
    test "returns the most recent path" do
      NavigationTracker.record_path(@mock_user_id, "/first")
      NavigationTracker.record_path(@mock_user_id, "/last")

      assert NavigationTracker.get_last_path(@mock_user_id) == "/last"
    end

    test "returns default path when no history exists" do
      assert NavigationTracker.get_last_path(@mock_user_id) == "/job_applications"
    end
  end

  describe "get_history/1" do
    test "returns empty list for user with no history" do
      assert NavigationTracker.get_history(@mock_user_id) == []
    end

    test "returns complete history for user" do
      paths = ["/path1", "/path2", "/path3"]

      Enum.reverse(paths)
      |> Enum.each(fn path ->
        NavigationTracker.record_path(@mock_user_id, path)
      end)

      history = NavigationTracker.get_history(@mock_user_id)
      assert length(history) == 3
      assert history == paths
    end
  end

  describe "clear_history/1" do
    test "removes all history for a user" do
      NavigationTracker.record_path(@mock_user_id, "/test")
      NavigationTracker.clear_history(@mock_user_id)

      assert NavigationTracker.get_history(@mock_user_id) == []
    end

    test "doesn't affect other users' history" do
      other_user = "other_user"

      NavigationTracker.record_path(@mock_user_id, "/user_path")
      NavigationTracker.record_path(other_user, "/other_path")

      NavigationTracker.clear_history(@mock_user_id)

      assert NavigationTracker.get_history(@mock_user_id) == []
      assert NavigationTracker.get_history(other_user) == ["/other_path"]

      NavigationTracker.clear_history(other_user)
    end
  end
end
