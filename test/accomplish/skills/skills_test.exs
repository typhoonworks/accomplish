defmodule Accomplish.SkillsTest do
  use Accomplish.DataCase

  alias Accomplish.Skills

  describe "find_or_create_skill/1" do
    test "creates a new skill if it does not exist" do
      skill = Skills.find_or_create_skill("Elixir")
      assert skill.name == "Elixir"
      assert skill.usage_count == 0
    end

    test "increments usage count when skill already exists" do
      skill1 = Skills.find_or_create_skill("React")
      assert skill1.name == "React"
      assert skill1.usage_count == 0

      skill2 = Skills.find_or_create_skill("React")
      assert skill2.name == "React"
      assert skill2.usage_count == skill1.usage_count + 1
    end
  end

  describe "create_skill/1" do
    test "creates a new skill if it does not exist" do
      skill = Skills.create_skill("Vue.js")
      assert skill.name == "Vue.js"
      assert skill.usage_count == 0
    end

    test "returns the existing skill without updating usage count" do
      skill1 = Skills.create_skill("Ruby on Rails")
      initial_usage = skill1.usage_count

      skill2 = Skills.create_skill("Ruby on Rails")
      assert skill2.id == skill1.id
      assert skill2.usage_count == initial_usage
    end
  end

  describe "increment_skill_usage/1" do
    test "increments usage count for an existing skill" do
      skill = Skills.create_skill("Node.js")
      initial_usage = skill.usage_count

      {:ok, updated_skill} = Skills.increment_skill_usage("Node.js")
      assert updated_skill.usage_count == initial_usage + 1
    end

    test "returns error when the skill is not found" do
      assert {:error, :skill_not_found} = Skills.increment_skill_usage("NonExistentSkill")
    end
  end

  describe "suggest_skills/2" do
    setup do
      Skills.create_skill("Elixir")
      Skills.create_skill("Elm")
      Skills.create_skill("Erlang")
      Skills.create_skill("React")
      Skills.create_skill("Redux")
      :ok
    end

    test "returns popular skills when query is empty" do
      skills = Skills.suggest_skills("", 10)
      assert length(skills) == 5
    end

    test "returns matching skills when query is provided" do
      skills = Skills.suggest_skills("el", 10)

      assert Enum.all?(skills, fn s ->
               String.starts_with?(String.downcase(s.name), "el")
             end)
    end
  end

  describe "list_skills/0" do
    setup do
      Skills.create_skill("Python")
      Skills.create_skill("Java")
      {:ok, _} = Skills.increment_skill_usage("Python")
      :ok
    end

    test "lists skills ordered by usage_count descending" do
      skills = Skills.list_skills()
      [first | _] = skills
      assert first.name == "Python"
    end
  end

  describe "get_skill!/1" do
    test "retrieves a skill by its id" do
      skill = Skills.create_skill("Go")
      fetched = Skills.get_skill!(skill.id)
      assert fetched.id == skill.id
      assert fetched.name == "Go"
    end

    test "raises an error if the skill is not found" do
      assert_raise Ecto.NoResultsError, fn ->
        Skills.get_skill!(UUIDv7.generate())
      end
    end
  end
end
