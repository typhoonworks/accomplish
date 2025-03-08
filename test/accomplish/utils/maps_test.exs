defmodule Accomplish.Utils.MapsTest do
  use ExUnit.Case, async: true
  alias Accomplish.Utils.Maps

  describe "atomize_keys/1" do
    test "converts string keys to atoms in a flat map" do
      _ = :foo
      _ = :bar

      input = %{"foo" => "value1", "bar" => "value2"}
      expected = %{foo: "value1", bar: "value2"}

      assert Maps.atomize_keys(input) == expected
    end

    test "handles mixed key types (binary and atom keys)" do
      _ = :key1
      _ = :key2

      input = %{"key1" => "val1", key2: "val2"}
      expected = %{key1: "val1", key2: "val2"}

      assert Maps.atomize_keys(input) == expected
    end

    test "recursively converts keys in nested maps" do
      _ = :outer
      _ = :inner

      input = %{"outer" => %{"inner" => "value"}}
      expected = %{outer: %{inner: "value"}}

      assert Maps.atomize_keys(input) == expected
    end

    test "recursively converts maps inside lists" do
      _ = :item1
      _ = :item2

      input = %{"list" => [%{"item1" => 1}, %{"item2" => 2}, "not a map"]}
      expected = %{list: [%{item1: 1}, %{item2: 2}, "not a map"]}

      assert Maps.atomize_keys(input) == expected
    end

    test "returns non-map input unchanged" do
      input = "just a string"
      assert Maps.atomize_keys(input) == input
    end

    test "handles an empty map" do
      assert Maps.atomize_keys(%{}) == %{}
    end
  end
end
