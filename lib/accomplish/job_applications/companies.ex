defmodule Accomplish.JobApplications.Companies do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.JobApplications.Company

  def get_or_create(name) do
    case get_by_name(name) do
      nil -> create_company(%{name: name})
      company -> {:ok, company}
    end
  end

  defp get_by_name(name) do
    Repo.get_by(Company, name: name)
  end

  defp create_company(attrs) do
    Company.create_changeset(attrs) |> Repo.insert()
  end
end
