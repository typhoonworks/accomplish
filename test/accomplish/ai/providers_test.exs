defmodule Accomplish.AI.ProvidersTest do
  use ExUnit.Case, async: true
  alias Accomplish.AI.Providers

  import ExUnit.CaptureLog

  describe "get_provider/1" do
    test "returns the correct adapter module for known providers" do
      assert Providers.get_provider(:anthropic) == Accomplish.AI.Adapters.Anthropic
      assert Providers.get_provider(:ollama) == Accomplish.AI.Adapters.Ollama
      assert Providers.get_provider(:fake) == Accomplish.AI.Adapters.Fake
    end

    test "returns the fake adapter for unknown providers" do
      assert Providers.get_provider(:unknown) == Accomplish.AI.Adapters.Fake
      assert Providers.get_provider(:nonexistent) == Accomplish.AI.Adapters.Fake
    end

    test "handles nil input by returning the fake adapter" do
      assert Providers.get_provider(nil) == Accomplish.AI.Adapters.Fake
    end
  end

  describe "get_model_for_provider/1" do
    test "returns the default model for known providers" do
      assert Providers.get_model_for_provider(:anthropic) == "claude-3-5-haiku-20241022"
      assert Providers.get_model_for_provider(:ollama) == "mistral:7b"
      assert Providers.get_model_for_provider(:fake) == "fake-model"
    end

    test "falls back to fake model with warning for unknown providers" do
      log =
        capture_log(fn ->
          assert Providers.get_model_for_provider(:unknown) == "fake-model"
        end)

      assert log =~ "Unknown provider unknown, using fake model"
    end
  end
end
