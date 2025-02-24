defmodule AccomplishWeb.Shadowrun.DatePicker do
  @moduledoc false

  use Phoenix.LiveComponent
  import AccomplishWeb.CoreComponents

  @week_start_at :sunday

  @impl true
  def render(assigns) do
    ~H"""
    <div class="date-picker mt-2">
      <input
        type="hidden"
        name={@start_date_field.name}
        id={@start_date_field.id}
        value={@start_date_field.value}
      />

      <button
        type="button"
        id={"#{@id}_open_button"}
        class={[
          "px-2.5 py-1 rounded-md text-xs font-light leading-normal transition-colors duration-150 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 flex items-center justify-center gap-2 border border-solid",
          case @variant do
            "default" -> "bg-zinc-700 text-zinc-200 hover:bg-zinc-600 shadow-md border-zinc-600"
            "transparent" -> "bg-transparent text-zinc-300 hover:bg-zinc-800 border-transparent"
          end,
          if(@start_date_field.errors != [], do: "border-red-700", else: "")
        ]}
        aria-expanded="false"
        aria-haspopup="true"
        phx-click="open-calendar"
        phx-target={@myself}
      >
        <.icon name="hero-calendar" class="size-4" />
        <span>{format_selected_date(@selected_date) || @label}</span>
      </button>

      <div
        :if={@calendar?}
        id={"#{@id}_calendar"}
        data-position={@position}
        class={[
          "absolute z-50 w-72 shadow-md transition-all",
          "data-[position=bottom]:top-full data-[position=bottom]:mt-2",
          "data-[position=top]:bottom-full data-[position=top]:mb-2",
          "data-[position=left]:right-full data-[position=left]:mr-2",
          "data-[position=right]:left-full data-[position=right]:ml-2"
        ]}
        phx-click-away="close-calendar"
        phx-target={@myself}
      >
        <div
          id="calendar_background"
          class="w-full bg-zinc-800 rounded-md ring-1 ring-zinc-700 bg-popover text-popover-foreground shadow-md focus:outline-none p-1"
        >
          <div class="w-full p-1.5 my-2">
            <label for={"#{@id}_display_value"} class="block text-xs text-zinc-400 mb-2">
              {@label}
            </label>
            <div>
              <input
                id={"#{@id}_display_value"}
                type="text"
                readonly
                placeholder={@placeholder}
                value={format_selected_date_with_year(@selected_date)}
                class="w-full px-2 py-1 bg-transparent text-zinc-200 text-[13px] placeholder:text-zinc-500 focus:outline-none border border-zinc-700 focus:border-transparent focus:ring-2 focus:ring-purple-700 rounded-md"
              />
              <p class="flex gap-2 text-xs leading-6 text-red-700">
                <%= for msg <- @start_date_field.errors do %>
                  {format_form_error(msg)}
                <% end %>
              </p>
            </div>
          </div>

          <div role="separator" class="relative -mx-1 h-px bg-zinc-700"></div>

          <div id="calendar_header" class="flex justify-between">
            <div id="current_month_year" class="self-center text-zinc-200 text-xs tracking-wide p-1.5">
              {@current.month}
            </div>
            <div class="flex p-1.5">
              <div id="button_left">
                <button
                  type="button"
                  phx-target={@myself}
                  phx-click="prev-month"
                  class="mr-1.5 p-1 text-zinc-400 hover:text-zinc-200 hover:bg-zinc-700 rounded-md"
                >
                  <.icon name="hero-chevron-left" class="size-4" />
                </button>
              </div>
              <div id="button_right">
                <button
                  type="button"
                  phx-target={@myself}
                  phx-click="next-month"
                  class="ml-1.5 p-1 text-zinc-400 hover:text-zinc-200 hover:bg-zinc-700 rounded-md"
                >
                  <.icon name="hero-chevron-right" class="size-4" />
                </button>
              </div>
            </div>
          </div>

          <div id="click_today" class="text-sm text-center">
            <.link
              phx-click="today"
              phx-target={@myself}
              class="text-xs text-zinc-400 hover:text-zinc-500"
            >
              Today
            </.link>
          </div>

          <div
            id="calendar_weekdays"
            class="text-center my-2 grid grid-cols-7 text-xs leading-6 text-zinc-400"
          >
            <div :for={week_day <- List.first(@current.week_rows)}>
              {Calendar.strftime(week_day, "%a")}
            </div>
          </div>

          <div role="separator" class="relative -mx-1 h-px bg-zinc-700"></div>

          <div
            id={"calendar_days_#{String.replace(@current.month, " ", "-")}"}
            class="isolate mt-2 grid grid-cols-7 gap-px text-sm"
          >
            <button
              :for={day <- Enum.flat_map(@current.week_rows, & &1)}
              type="button"
              phx-target={@myself}
              phx-click="pick-date"
              phx-value-date={Calendar.strftime(day, "%Y-%m-%d") <> "T00:00:00Z"}
              class={[
                "calendar-day overflow-hidden py-1 h-10 w-auto focus:z-10 text-sm",
                today?(day) && "font-semibold bg-zinc-700 ring-1 ring-zinc-500",
                (before_min_date?(day, @min) or after_max_date?(day, @max)) &&
                  "text-zinc-400/10 cursor-not-allowed",
                (!before_min_date?(day, @min) and not after_max_date?(day, @max)) &&
                  "hover:bg-purple-700 rounded-full text-zinc-50",
                other_month?(day, @current.date) && "text-zinc-500",
                selected_date?(day, @selected_date) &&
                  "hover:bg-purple-700 bg-purple-700 text-zinc-50"
              ]}
            >
              <time
                class="mx-auto flex h-4 w-4 items-center justify-center rounded-full"
                datetime={Calendar.strftime(day, "%Y-%m-%d")}
              >
                {Calendar.strftime(day, "%d")}
              </time>
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    current_date = Date.utc_today()

    {
      :ok,
      socket
      |> assign(:calendar?, false)
      |> assign(:current, format_date(current_date))
      |> assign(:selected_date, nil)
      |> assign(:readonly, false)
      |> assign(:form, nil)
    }
  end

  @impl true
  def update(assigns, socket) do
    # For a single date, only use the start_date_field value
    selected_date = from_str!(assigns.start_date_field.value)
    current_date = socket.assigns.current.date

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:current, format_date(current_date))
      |> assign(:selected_date, selected_date)
    }
  end

  @impl true
  def handle_event("open-calendar", _, socket) do
    {:noreply, assign(socket, :calendar?, true)}
  end

  @impl true
  def handle_event("close-calendar", _, socket) do
    {:noreply, close_calendar(socket)}
  end

  @impl true
  def handle_event("today", _, socket) do
    new_date = Date.utc_today()
    {:noreply, assign(socket, :current, format_date(new_date))}
  end

  @impl true
  def handle_event("prev-month", _, socket) do
    new_date = new_date(socket.assigns)
    {:noreply, assign(socket, :current, format_date(new_date))}
  end

  @impl true
  def handle_event("next-month", _, socket) do
    last_row = socket.assigns.current.week_rows |> List.last()
    new_date = next_month_new_date(socket.assigns.current.date, last_row)
    {:noreply, assign(socket, :current, format_date(new_date))}
  end

  @impl true
  def handle_event("pick-date", %{"date" => date_str}, socket) do
    date_time = from_str!(date_str)
    date = DateTime.to_date(date_time)

    cond do
      Date.compare(socket.assigns.min, date) == :gt ->
        {:noreply, socket}

      Date.compare(date, socket.assigns.max) == :gt ->
        {:noreply, socket}

      true ->
        {:noreply,
         socket
         |> assign(:selected_date, date_time)
         |> close_calendar()}
    end
  end

  defp close_calendar(socket) do
    if socket.assigns.selected_date do
      updated_socket =
        socket
        |> assign(:calendar?, false)
        |> assign(
          :start_date_field,
          set_field_value(socket.assigns, :start_date_field, socket.assigns.selected_date)
        )

      send(self(), %{
        id: socket.assigns.id,
        field: socket.assigns.start_date_field.field,
        date: socket.assigns.selected_date,
        form: socket.assigns.form
      })

      updated_socket
    else
      assign(socket, :calendar?, false)
    end
  end

  defp next_month_new_date(current_date, last_row) do
    last_row_last_day = List.last(last_row)
    last_row_last_month = Calendar.strftime(last_row_last_day, "%B")
    last_row_first_month = Calendar.strftime(List.first(last_row), "%B")
    current_month = Calendar.strftime(current_date, "%B")

    next_month =
      if last_row_first_month == last_row_last_month do
        last_row_last_day
        |> Date.end_of_month()
        |> Date.add(1)
        |> Calendar.strftime("%B")
      else
        last_row_last_month
      end

    if current_date in last_row and current_month == next_month do
      current_date
    else
      current_date |> Date.end_of_month() |> Date.add(1)
    end
  end

  defp new_date(%{current: %{date: current_date, week_rows: week_rows}}) do
    first_row = List.first(week_rows)
    last_row = List.last(week_rows)

    if current_date in last_row do
      first_row |> List.last() |> Date.beginning_of_month() |> Date.add(-1)
    else
      current_date |> Date.beginning_of_month() |> Date.add(-1)
    end
  end

  defp week_rows(current_date) do
    first =
      current_date
      |> Date.beginning_of_month()
      |> Date.beginning_of_week(@week_start_at)

    last =
      current_date
      |> Date.end_of_month()
      |> Date.end_of_week(@week_start_at)

    Date.range(first, last)
    |> Enum.map(& &1)
    |> Enum.chunk_every(7)
  end

  defp set_field_value(nil, _field, _value), do: nil

  defp set_field_value(assigns, field, value) when is_binary(value) do
    if Map.has_key?(assigns, field) and is_map(assigns[field]) do
      {:ok, value, _} = DateTime.from_iso8601(value)
      Map.put(assigns[field], :value, value)
    else
      nil
    end
  end

  defp set_field_value(assigns, field, value) do
    if Map.has_key?(assigns, field) and is_map(assigns[field]) do
      {:ok, value, _} = DateTime.from_iso8601(Date.to_string(value) <> "T00:00:00Z")
      Map.put(assigns[field], :value, value)
    else
      nil
    end
  end

  defp before_min_date?(day, min), do: Date.compare(day, min) == :lt
  defp after_max_date?(day, max), do: Date.compare(day, max) == :gt
  defp today?(day), do: day == Date.utc_today()

  defp other_month?(day, current_date),
    do: Date.beginning_of_month(day) != Date.beginning_of_month(current_date)

  defp selected_date?(day, selected_date) do
    case selected_date do
      nil -> false
      _ -> day == DateTime.to_date(selected_date)
    end
  end

  defp format_date(date) do
    %{
      date: date,
      month: Calendar.strftime(date, "%B %Y"),
      week_rows: week_rows(date)
    }
  end

  defp format_selected_date(nil), do: nil
  defp format_selected_date(date), do: Calendar.strftime(DateTime.to_date(date), "%b %d")

  defp format_selected_date_with_year(nil), do: nil

  defp format_selected_date_with_year(date) do
    Calendar.strftime(DateTime.to_date(date), "%b %d, %Y")
  end

  defp format_form_error({_key, {msg, _type}}), do: msg
  defp format_form_error({msg, _type}), do: msg

  defp from_str!(""), do: nil

  defp from_str!(date_time_str) when is_binary(date_time_str) do
    case DateTime.from_iso8601(date_time_str) do
      {:ok, date_time, _} -> date_time
      _ -> nil
    end
  end

  defp from_str!(date_time_str), do: date_time_str
end
