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
    |> Validators.validate_url(:website_url, strict: false)
  end
end
