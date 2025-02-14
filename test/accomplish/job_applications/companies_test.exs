defmodule Accomplish.CompaniesTest do
  use Accomplish.DataCase

  alias Accomplish.Companies

  describe "get_or_create/1" do
    setup do
      %{company: company_fixture(%{name: "Typhoon Works"})}
    end

    test "returns the existing company when it exists", %{company: company} do
      assert {:ok, existing_company} = Companies.get_or_create("Typhoon Works")
      assert existing_company.id == company.id
    end

    test "creates and returns a new company when it does not exist" do
      assert {:ok, new_company} = Companies.get_or_create("Nonexistent Corp")
      assert new_company.name == "Nonexistent Corp"
      assert new_company.id != nil
    end
  end
end
