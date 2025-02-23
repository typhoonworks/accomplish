defmodule Accomplish.Slug do
  @moduledoc false

  import Ecto.Changeset

  @slug_pattern ~r/^[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*$/

  def slugify(string) when is_binary(string) do
    string
    |> String.downcase()
    |> String.trim()
    |> String.replace(~r/[^a-z0-9-]+/, "-")
    |> String.replace(~r/-+/, "-")
    |> String.replace(~r/^-+|-+$/, "")
  end

  def slugify(list) when is_list(list) do
    Enum.map_join(list, "--", &slugify/1)
  end

  def slugify(_), do: nil

  def validate_slug_format(changeset, field_name) do
    validate_format(changeset, field_name, @slug_pattern,
      message: "is invalid. Only letters, numbers, and connecting hyphens are allowed."
    )
  end
end
