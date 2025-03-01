defmodule AccomplishWeb.TimeHelpers do
  @moduledoc """
  A set of time-related helper functions using `Timex`.

  These helpers provide formatted dates, relative times, and timezone conversions.
  """

  @doc """
  Formats a given date/time as a relative time string.

  ## Examples

      iex> formatted_relative_time(~N[2025-02-16 10:00:00])
      "2 hours ago"

      iex> formatted_relative_time(~N[2025-02-15 08:00:00])
      "1 day ago"
  """
  def formatted_relative_time(date, timezone \\ "UTC") do
    date
    |> Timex.to_datetime(timezone)
    |> Timex.format!("{relative}", :relative)
  end

  @doc """
  Formats a given date/time to a 12-hour clock format.

  ## Examples

      iex> formatted_time(~N[2025-02-16 14:30:00])
      "2:30 PM"

      iex> formatted_time(~N[2025-02-16 09:05:00])
      "9:05 AM"
  """
  def formatted_time(date, timezone \\ "UTC") do
    date
    |> Timex.to_datetime(timezone)
    |> Timex.format!("{h12}:{m} {AM}")
  end

  @doc """
  Formats a given date/time to a full YYYY-MM-DD format.

  ## Examples

      iex> formatted_full_date(~N[2025-02-16 14:30:00])
      "2025-02-16"

      iex> formatted_full_date(~N[2023-07-01 00:00:00])
      "2023-07-01"
  """
  def formatted_full_date(date, timezone \\ "UTC") do
    date
    |> Timex.to_datetime(timezone)
    |> Timex.format!("{YYYY}-{0M}-{0D}")
  end

  @doc """
  Formats a given date/time to a human-readable date format (D Mmm YYYY).

  ## Examples

      iex> formatted_human_date(~N[2025-02-16 14:30:00])
      "16 Feb 2025"

      iex> formatted_human_date(~N[2024-12-25 00:00:00])
      "25 Dec 2024"
  """
  def formatted_human_date(date, timezone \\ "UTC") do
    date
    |> Timex.to_datetime(timezone)
    |> Timex.format!("{0D} {Mshort} {YYYY}")
  end

  @doc """
  Formats a given datetime to a full date and time string.

  ## Examples

      iex> formatted_full_datetime(~U[2025-02-16 14:30:00Z])
      "16 Feb 2025, 14:30 UTC"

      iex> formatted_full_datetime(~U[2025-02-16 09:05:00Z], "America/New_York")
      "16 Feb 2025, 04:05 EST"
  """
  def formatted_full_datetime(date, timezone \\ "UTC") do
    date
    |> Timex.to_datetime(timezone)
    |> Timex.format!("{0D} {Mshort} {YYYY}, {h24}:{0m}")
  end

  @doc """
  Extracts the day of the month from a date.

  ## Examples

      iex> formatted_day(~N[2025-02-16 14:30:00])
      "16"

      iex> formatted_day(~N[2024-12-01 00:00:00])
      "1"
  """
  def formatted_day(date, timezone \\ "UTC") do
    date
    |> Timex.to_datetime(timezone)
    |> Timex.format!("{D}")
  end

  @doc """
  Formats a given date/time to a short weekday name.

  ## Examples

      iex> formatted_weekday_short(~N[2025-02-16 14:30:00])
      "Sun"

      iex> formatted_weekday_short(~N[2024-12-25 00:00:00])
      "Wed"
  """
  def formatted_weekday_short(date, timezone \\ "UTC") do
    date
    |> Timex.to_datetime(timezone)
    |> Timex.format!("{WDshort}")
  end

  @doc """
  Formats a given date to "Month Year" format.

  ## Examples

      iex> formatted_month_year(~N[2025-02-16 14:30:00])
      "February 2025"

      iex> formatted_month_year(~N[2024-07-01 00:00:00])
      "July 2024"
  """
  def formatted_month_year(date, timezone \\ "UTC") do
    date
    |> Timex.to_datetime(timezone)
    |> Timex.format!("{Mfull} {YYYY}")
  end

  @doc """
  Retrieves the user's timezone from the LiveView socket or session.

  ## Examples

      iex> get_timezone(socket, %{"timezone" => "America/New_York"})
      "America/New_York"

      iex> get_timezone(socket, %{})
      "UTC"
  """
  def get_timezone(socket, session) do
    if Phoenix.LiveView.connected?(socket) do
      case Phoenix.LiveView.get_connect_params(socket) do
        %{"timezone" => timezone} -> timezone
        _ -> session["timezone"] || "UTC"
      end
    else
      session["timezone"] || "UTC"
    end
  end

  @doc """
  Returns a list of dates for the current week.

  ## Examples

      iex> get_week_dates(~D[2025-02-16], :monday)
      [~D[2025-02-10], ~D[2025-02-11], ~D[2025-02-12], ..., ~D[2025-02-16]]

      iex> get_week_dates(~D[2025-02-16], :sunday)
      [~D[2025-02-09], ~D[2025-02-10], ..., ~D[2025-02-15]]
  """
  def get_week_dates(current_date, start_of_week \\ :monday) do
    start_date = Timex.beginning_of_week(current_date, start_of_week)
    for i <- 0..6, do: Timex.shift(start_date, days: i)
  end

  @doc """
  Returns the current date in the given timezone.

  ## Examples

      iex> current_date("UTC")
      ~D[2025-02-16]

      iex> current_date("America/New_York")
      ~D[2025-02-16]
  """
  def current_date(timezone \\ "UTC"), do: Timex.now(timezone) |> Timex.to_date()

  @doc """
  Returns the current datetime in the given timezone.

  ## Examples

      iex> current_datetime("UTC")
      ~U[2025-02-16 14:30:00Z]

      iex> current_datetime("America/New_York")
      ~U[2025-02-16 09:30:00-05:00]
  """
  def current_datetime(timezone \\ "UTC"), do: Timex.now(timezone)

  @doc """
  Checks if a given date is today.

  ## Examples

      iex> today?(~D[2025-02-16])
      true

      iex> today?(~D[2025-02-15])
      false
  """
  def today?(date, timezone \\ "UTC") do
    date_in_tz = Timex.to_datetime(date, timezone)
    current_date_in_tz = Timex.to_datetime(current_date(), timezone)

    Timex.compare(date_in_tz, current_date_in_tz) == 0
  end

  @doc """
  Determines the period of the day (morning, afternoon, evening) based on the current hour.

  ## Examples

      iex> time_period_of_day("UTC")
      :afternoon

      iex> time_period_of_day("America/New_York")
      :morning
  """
  def time_period_of_day(timezone \\ "UTC") do
    current_hour =
      Timex.now(timezone)
      |> Timex.to_datetime(timezone)
      |> Timex.format!("{h24}")
      |> String.to_integer()

    cond do
      current_hour < 12 ->
        :morning

      current_hour < 18 ->
        :afternoon

      true ->
        :evening
    end
  end

  @doc """
  Converts a given time to a specified timezone.

  ## Examples

      iex> to_timezone(~U[2025-02-16 14:30:00Z], "America/New_York")
      ~N[2025-02-16 09:30:00]

      iex> to_timezone(~U[2025-02-16 00:00:00Z], "Asia/Tokyo")
      ~N[2025-02-16 09:00:00]
  """
  def to_timezone(time, timezone) do
    datetime = Timex.to_datetime(time, "Etc/UTC") |> Timex.Timezone.convert(timezone)
    Timex.to_naive_datetime(datetime)
  end

  @doc """
  Returns a greeting based on the time of day.

  ## Examples

      iex> say_greeting("UTC")
      "Good afternoon"

      iex> say_greeting("America/New_York")
      "Good morning"
  """
  def say_greeting(timezone \\ "UTC") do
    case time_period_of_day(timezone) do
      :morning -> "Good morning"
      :afternoon -> "Good afternoon"
      :evening -> "Good evening"
    end
  end
end
