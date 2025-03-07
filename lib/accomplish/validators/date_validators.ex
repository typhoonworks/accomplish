defmodule Accomplish.DateValidators do
  @moduledoc """
  Provides common date-related validation functions for Ecto changesets.
  """

  import Ecto.Changeset

  @doc """
  Validates that a start date is before or equal to an end date.

  ## Options
    * `:start_date_field` - The name of the start date field (default: `:start_date`)
    * `:end_date_field` - The name of the end date field (default: `:end_date`)
    * `:message` - Custom error message (default provided)

  ## Examples

      # In a changeset
      def changeset(struct, attrs) do
        struct
        |> cast(attrs, [:start_date, :end_date])
        |> validate_start_date_before_end_date()
      end

      # With custom fields
      def changeset(struct, attrs) do
        struct
        |> cast(attrs, [:begins_at, :ends_at])
        |> validate_start_date_before_end_date(
          start_date_field: :begins_at,
          end_date_field: :ends_at
        )
      end
  """
  def validate_start_date_before_end_date(changeset, opts \\ []) do
    start_date_field = Keyword.get(opts, :start_date_field, :start_date)
    end_date_field = Keyword.get(opts, :end_date_field, :end_date)
    message = Keyword.get(opts, :message, "must be after the start date")

    start_date = get_change(changeset, start_date_field)
    end_date = get_change(changeset, end_date_field)

    case {start_date, end_date} do
      {%Date{}, %Date{}} ->
        if Date.compare(start_date, end_date) == :gt do
          add_error(changeset, end_date_field, message)
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  @doc """
  Validates that a date is not in the future.

  ## Options
    * `:field` - The name of the date field (default: `:date`)
    * `:message` - Custom error message (default provided)
    * `:today` - Allows overriding the current date for testing (default: current date)

  ## Examples

      # In a changeset
      def changeset(struct, attrs) do
        struct
        |> cast(attrs, [:date])
        |> validate_date_not_in_future()
      end
  """
  def validate_date_not_in_future(changeset, opts \\ []) do
    field = Keyword.get(opts, :field, :date)
    message = Keyword.get(opts, :message, "cannot be in the future")
    today = Keyword.get(opts, :today, Date.utc_today())

    date = get_change(changeset, field)

    case date do
      %Date{} ->
        if Date.compare(date, today) == :gt do
          add_error(changeset, field, message)
        else
          changeset
        end

      _ ->
        changeset
    end
  end
end
