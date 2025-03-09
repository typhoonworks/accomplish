defmodule AccomplishWeb.Components.JobApplicationTimeline do
  use AccomplishWeb, :live_component
  import AccomplishWeb.TimeHelpers

  def render(assigns) do
    timezone = assigns[:timezone] || "UTC"
    current_date = current_date(timezone)

    start_date = get_start_date(assigns.applications, current_date)
    end_date = get_end_date(assigns.applications, current_date)
    months = generate_month_headers(start_date, end_date, timezone)
    intervals = generate_intervals(start_date, end_date, current_date)
    timeline_data = prepare_timeline_data(assigns.applications, start_date, current_date)

    assigns =
      assign(assigns, %{
        timezone: timezone,
        current_date: current_date,
        start_date: start_date,
        end_date: end_date,
        months: months,
        intervals: intervals,
        timeline_data: timeline_data
      })

    ~H"""
    <div
      id={@id}
      class="bg-zinc-950 border-t border-zinc-700 overflow-hidden h-full flex flex-col px-6"
    >
      <div class="text-sm text-zinc-200 px-6 py-4 flex items-center">
        <.lucide_icon name="calendar-days" class="size-4 mr-2" /> Job Application Timeline
      </div>

      <div class="overflow-x-auto scrollbar-thin scrollbar-thumb-zinc-700 scrollbar-track-zinc-900 flex-1">
        <div class="min-w-max px-6 pb-6">
          <div class="flex border-b border-zinc-700 pb-2">
            <!-- Left side reserved for application titles -->
            <div class="w-52 flex-shrink-0"></div>
            
    <!-- Month columns -->
            <div class="flex flex-1">
              <%= for {month_date, month_width, is_current} <- @months do %>
                <div
                  class={"relative flex-none text-xs text-zinc-400 font-medium #{if is_current, do: "text-purple-400", else: ""}"}
                  style={"width: #{month_width}px"}
                >
                  <%= if month_date.month == 1 or month_date.day == 1 do %>
                    {formatted_month_year(month_date)}
                  <% else %>
                    {Timex.format!(month_date, "{Mshort}")}
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>
          
    <!-- Day intervals -->
          <div class="flex relative">
            <!-- Left side reserved for application titles -->
            <div class="w-52 flex-shrink-0"></div>
            
    <!-- Day interval marks -->
            <div class="flex flex-1 relative">
              <%= for {date, interval_width, is_current} <- @intervals do %>
                <div
                  class={"flex-none border-l border-zinc-700/30 text-xs text-zinc-500 #{if is_current, do: "border-l-2 border-purple-500", else: ""}"}
                  style={"width: #{interval_width}px"}
                >
                  <%= if rem(date.day, 5) == 0 do %>
                    <span class="pl-1">{formatted_day(date)}</span>
                  <% end %>
                </div>
              <% end %>
              
    <!-- Current date vertical line -->
              <div
                class="absolute top-0 bottom-0 w-[2px] bg-purple-500 z-10"
                style={"left: #{calculate_current_date_position(@start_date, @current_date)}px"}
              >
              </div>
            </div>
          </div>
          
    <!-- Application rows -->
          <%= if Enum.empty?(@applications) do %>
            <div class="text-center py-8 text-zinc-500 text-sm h-full flex flex-col justify-center">
              <p class="mt-2">No applications yet</p>
            </div>
          <% else %>
            <%= for application <- @applications do %>
              <div class="flex items-center py-2">
                <!-- Application info -->
                <div class="w-52 flex-shrink-0 p-4 rounded-md hover:bg-zinc-700/20">
                  <.link
                    navigate={~p"/job_application/#{application.slug}/overview"}
                    class="font-light text-zinc-200 text-sm truncate block"
                  >
                    {application.role}
                  </.link>
                  <p class="text-zinc-500 text-xs truncate">{application.company.name}</p>
                </div>
                
    <!-- Timeline bar -->
                <div class="flex-1 relative min-h-[30px]">
                  <%= if Map.has_key?(@timeline_data, application.id) do %>
                    <% app_timeline = @timeline_data[application.id] %>
                    <div
                      class="absolute top-[10px] h-[10px] rounded-md flex items-center"
                      style={"left: #{app_timeline.start_pos}px; width: #{app_timeline.width}px;"}
                    >
                      <!-- Past to present portion -->
                      <div
                        class={"h-full rounded-l-md #{status_color_bg(application.status)}"}
                        style={"width: #{app_timeline.current_width}px"}
                      >
                      </div>
                      
    <!-- Future portion -->
                      <div
                        class={"h-full rounded-r-md bg-opacity-30 border-dashed border #{status_color_border(application.status)}"}
                        style={"width: #{app_timeline.future_width}px"}
                      >
                      </div>
                    </div>
                  <% end %>
                </div>
              </div>
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp prepare_timeline_data(applications, start_date, current_date) do
    applications
    |> Enum.map(fn app ->
      # Use applied_at as primary date or inserted_at as fallback
      app_date = app.applied_at || app.inserted_at
      app_start_date = DateTime.to_date(app_date)

      # Calculate position and width in pixels
      days_from_start = max(Date.diff(app_start_date, start_date), 0)
      days_to_current = min(Date.diff(current_date, app_start_date), 14)
      future_days = 14 - days_to_current

      # Ensure future_days is not negative
      future_days = max(future_days, 0)

      # Each day is 20px wide
      start_pos = days_from_start * 20
      current_width = days_to_current * 20
      future_width = future_days * 20
      width = current_width + future_width

      {app.id,
       %{
         start_pos: start_pos,
         width: width,
         current_width: current_width,
         future_width: future_width,
         start_date: app_start_date
       }}
    end)
    |> Map.new()
  end

  defp get_start_date(applications, current_date) do
    # Find earliest application date or default to 3 months ago
    earliest_date =
      applications
      |> Enum.map(fn app ->
        app_date = app.applied_at || app.inserted_at
        DateTime.to_date(app_date)
      end)
      |> Enum.min(fn -> Timex.shift(current_date, months: -3) end)

    # Ensure we show at least the current month start
    current_month_start = Timex.beginning_of_month(current_date)

    # Choose the earlier date between earliest application and current month start
    if Timex.compare(earliest_date, current_month_start) == -1 do
      # Go to the beginning of the month for the earliest date
      Timex.beginning_of_month(earliest_date)
    else
      current_month_start
    end
  end

  defp get_end_date(_applications, current_date) do
    # Add 2 weeks to current date
    latest_future_date = Timex.shift(current_date, days: 14)

    # Default to end of month containing the future date
    Timex.end_of_month(latest_future_date)
  end

  defp generate_month_headers(start_date, end_date, timezone) do
    current_date = current_date(timezone)

    # Get all the first days of months in the range
    months = get_months_in_range(start_date, end_date)

    months
    |> Enum.map(fn date ->
      # Calculate the width of this month in pixels
      days_in_month = Timex.days_in_month(date)
      # Each day is 20px
      width = days_in_month * 20

      # Check if this is the current month
      is_current_month = date.year == current_date.year && date.month == current_date.month

      {date, width, is_current_month}
    end)
  end

  defp get_months_in_range(start_date, end_date) do
    # Get all first days of months in the date range
    Stream.unfold(start_date, fn date ->
      if Timex.compare(date, end_date) > 0 do
        nil
      else
        next_date = Timex.shift(date, months: 1)
        {date, next_date}
      end
    end)
    |> Enum.map(fn date -> Timex.beginning_of_month(date) end)
    |> Enum.uniq()
  end

  defp generate_intervals(start_date, end_date, current_date) do
    # Generate all days between start_date and end_date
    Timex.Interval.new(from: start_date, until: end_date, step: [days: 1])
    |> Enum.map(fn date ->
      is_current = Timex.compare(date, current_date) == 0
      # Each interval is 20px wide
      {date, 20, is_current}
    end)
  end

  defp calculate_current_date_position(start_date, current_date) do
    days_from_start = Timex.diff(current_date, start_date, :days)
    # Each day is 20px
    days_from_start * 20
  end

  defp status_color_bg("draft"), do: "bg-slate-600"
  defp status_color_bg("accepted"), do: "bg-purple-600"
  defp status_color_bg("offer"), do: "bg-blue-600"
  defp status_color_bg("applied"), do: "bg-green-600"
  defp status_color_bg("interviewing"), do: "bg-yellow-600"
  defp status_color_bg("rejected"), do: "bg-red-600"
  defp status_color_bg("ghosted"), do: "bg-zinc-600"
  defp status_color_bg(_), do: "bg-zinc-600"

  defp status_color_border("draft"), do: "border-slate-600"
  defp status_color_border("accepted"), do: "border-purple-600"
  defp status_color_border("offer"), do: "border-blue-600"
  defp status_color_border("applied"), do: "border-green-600"
  defp status_color_border("interviewing"), do: "border-yellow-600"
  defp status_color_border("rejected"), do: "border-red-600"
  defp status_color_border("ghosted"), do: "border-zinc-600"
  defp status_color_border(_), do: "border-zinc-600"
end
