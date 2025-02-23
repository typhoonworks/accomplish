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
end
