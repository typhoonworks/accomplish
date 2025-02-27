defmodule Accomplish.SlugTest do
  use ExUnit.Case

  alias Accomplish.Slug

  test "slugify/1 with a string returns the slugified string" do
    assert Slug.slugify("Some String") == "some-string"
    assert Slug.slugify("Some String 123") == "some-string-123"
    assert Slug.slugify("SomeString!!!") == "somestring"
  end

  test "slugify/1 with a list of string returns their slugified concatenation" do
    list = ["Software Engineer", "Typhoon Works"]
    assert Slug.slugify(list) == "software-engineer--typhoon-works"
  end

  describe "add_suffix/2" do
    setup do
      valid_uuidv7 = "017f22e3-8f1c-7b93-92ae-16c4a6d87cf4"
      invalid_uuid = "not-a-uuid"

      %{valid_uuidv7: valid_uuidv7, invalid_uuid: invalid_uuid}
    end

    test "appends UUIDv7 suffix when given a valid UUIDv7", %{valid_uuidv7: valid_uuidv7} do
      assert Slug.add_suffix("software-engineer", valid_uuidv7) ==
               "software-engineer-16c4a6d87cf4"
    end

    test "returns original slug if ID is not a UUIDv7", %{invalid_uuid: invalid_uuid} do
      assert Slug.add_suffix("software-engineer", invalid_uuid) == "software-engineer"
    end

    test "returns original slug if ID is nil" do
      assert Slug.add_suffix("software-engineer", nil) == "software-engineer"
    end

    test "returns original slug if ID is an empty string" do
      assert Slug.add_suffix("software-engineer", "") == "software-engineer"
    end
  end
end
