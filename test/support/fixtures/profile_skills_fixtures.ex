defmodule Accomplish.ProfileSkillsFixtures do
  @moduledoc """
  This module defines test helpers for creating skills via the `Accomplish.Profiles.Skills` context.
  """

  alias Accomplish.Profiles.Skills

  @doc """
  Returns a skill fixture.

  By default, creates a skill with the given name (or "Elixir" if not provided) using `create_skill/1`.
  """
  def skill_fixture(attrs \\ %{}) do
    name = Map.get(attrs, :name, "Elixir")
    Skills.create_skill(name)
  end
end
