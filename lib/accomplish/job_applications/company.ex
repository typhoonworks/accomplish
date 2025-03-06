defmodule Accomplish.JobApplications.Company do
  @moduledoc false

  use Accomplish.Schema

  @primary_key false

  @permitted ~w(name website_url)a
  @required ~w(name)a

  embedded_schema do
    field :name, :string
    field :website_url, :string
  end

  def changeset(company, attrs \\ %{}) do
    company
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> maybe_validate_url()
  end

  defp maybe_validate_url(changeset) do
    case get_field(changeset, :website_url) do
      nil -> changeset
      "" -> changeset
      _ -> Validators.validate_url(changeset, :website_url, strict: false)
    end
  end
end
