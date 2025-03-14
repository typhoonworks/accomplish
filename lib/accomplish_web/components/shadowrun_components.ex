defmodule AccomplishWeb.ShadowrunComponents do
  @moduledoc false

  use Phoenix.Component
  use LiveSvelte.Components

  use Gettext, backend: AccomplishWeb.Gettext

  alias Phoenix.LiveView.JS

  import AccomplishWeb.CoreComponents
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu

  defp classes(input) do
    TwMerge.merge(input)
  end

  attr :class, :string, default: nil

  def unread_badge(assigns) do
    ~H"""
    <div class="flex items-center justify-center">
      <span class={classes(["size-2 rounded-full bg-purple-600 ring-1 ring-purple-400", @class])}>
      </span>
    </div>
    """
  end

  attr :variant, :string,
    default: "default",
    values: ["default", "info", "success", "warning", "error"]

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def shadow_pill(assigns) do
    ~H"""
    <span
      class={
        classes([
          "inline-flex items-center px-3 py-1 rounded-full text-xs font-light",
          "border border-zinc-200 border-solid transition-all",
          pill_variant_class(@variant),
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp pill_variant_class("default"),
    do: "border-zinc-600 text-zinc-300 ring-zinc-700 hover:ring-zinc-600"

  defp pill_variant_class("info"),
    do: "border-blue-600 text-blue-300 ring-blue-700 hover:ring-blue-600"

  defp pill_variant_class("success"),
    do: "border-green-600 text-green-300 ring-green-700 hover:ring-green-600"

  defp pill_variant_class("warning"),
    do: "border-yellow-600 text-yellow-300 ring-yellow-700 hover:ring-yellow-600"

  defp pill_variant_class("error"),
    do: "border-red-600 text-red-300 ring-red-700 hover:ring-red-600"

  attr :type, :string, default: "button"
  attr :variant, :string, default: "primary", values: ["primary", "secondary", "transparent"]
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def shadow_button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "px-2.5 py-1 rounded-md text-xs font-light leading-normal transition-colors duration-150",
        "focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2",
        "flex items-center justify-center gap-2",
        button_variant_class(@variant),
        @disabled && "opacity-50 cursor-not-allowed",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp button_variant_class("primary"),
    do:
      "bg-purple-700 text-zinc-50 hover:bg-purple-600 border border-solid border-purple-600 shadow-md"

  defp button_variant_class("secondary"),
    do:
      "bg-zinc-700 text-zinc-200 hover:bg-zinc-600 border border-solid border-zinc-600 shadow-md"

  defp button_variant_class("transparent"),
    do: "bg-transparent text-zinc-300 hover:bg-zinc-800 border-transparent"

  attr :active, :boolean, default: false
  attr :icon, :string, default: nil
  attr :text, :string, required: true
  attr :href, :string, required: true

  def nav_button(assigns) do
    ~H"""
    <.link
      href={@href}
      class={[
        "group flex items-center gap-2 px-2 py-1.5 text-[13px] tracking-tight rounded-md transition-all",
        "hover:bg-zinc-800 hover:text-zinc-50",
        if(@active, do: "bg-zinc-700 text-zinc-50 shadow-sm", else: "bg-zinc-900 text-zinc-400")
      ]}
    >
      <%= if @icon do %>
        <.lucide_icon
          name={@icon}
          class="size-4 shrink-0 group-hover:scale-110 group-hover:text-zinc-50 text-current"
        />
      <% end %>
      <span>{@text}</span>
    </.link>
    """
  end

  attr :is_saving, :boolean, required: true
  attr :class, :string, default: "text-xs text-zinc-400"
  attr :saved_text, :string, default: "Saved"
  attr :saving_text, :string, default: "Saving..."

  def saving_indicator(assigns) do
    ~H"""
    <div class={classes(["text-xs text-zinc-400", @class])}>
      <%= if @is_saving do %>
        <div class="flex items-center gap-1">
          <.lucide_icon name="loader" class="size-3 animate-spin" />
          <span>{@saving_text}</span>
        </div>
      <% else %>
        <div class="flex items-center gap-1">
          <.lucide_icon name="check" class="size-3" />
          <span>{@saved_text}</span>
        </div>
      <% end %>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :class, :string, required: false, default: "icon"
  attr :rest, :global

  def lucide_icon(assigns) do
    ~H"""
    <Lucide.render icon={@name} class={@class} {@rest} />
    """
  end

  attr :id, :string, default: nil
  attr :variant, :string, default: "horizontal", values: ["horizontal", "vertical"]
  attr :size, :integer, default: 100
  attr :full, :boolean, default: nil

  def separator(assigns) do
    assigns = assign_new(assigns, :full, fn -> assigns.size == 100 end)

    ~H"""
    <div
      role="separator"
      id={@id}
      class={[
        "relative bg-zinc-700",
        if @variant == "horizontal" do
          if @full, do: "w-full h-px -mx-1", else: "#{width_class(@size)} h-px"
        else
          if @full, do: "h-full w-px -my-1", else: "#{height_class(@size)} w-px"
        end
      ]}
    >
    </div>
    """
  end

  defp width_class(size), do: map_size_to_class(size, "w")
  defp height_class(size), do: map_size_to_class(size, "h")

  defp map_size_to_class(size, prefix) do
    closest =
      [100, 75, 50, 25]
      |> Enum.min_by(fn n -> abs(n - size) end)

    "#{prefix}-#{fractional_class(closest)}"
  end

  defp fractional_class(100), do: "full"
  defp fractional_class(75), do: "3/4"
  defp fractional_class(50), do: "1/2"
  defp fractional_class(25), do: "1/4"
  defp fractional_class(_), do: "full"

  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def shadow_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="space-y-4">
        {render_slot(@inner_block, f)}
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          {render_slot(action, f)}
        </div>
      </div>
    </.form>
    """
  end

  attr :id, :any, default: nil
  attr :class, :string, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :autosave, :boolean, default: false
  attr :autosave_delay, :integer, default: 1500
  attr :streaming, :boolean, default: false
  attr :streaming_complete, :boolean, default: false

  attr :socket, :any

  attr :rest, :global,
    include:
      ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step autosave autosave_delay)

  def shadow_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> shadow_input()
  end

  def shadow_input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div>
      <label class="flex items-center gap-3 text-[13px] text-zinc-400">
        <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="size-4 rounded bg-zinc-800 border-zinc-600 checked:border-transparent checked:bg-zinc-50 focus:ring-0"
          {@rest}
        />
        {@label}
      </label>
      <.shadow_error :for={msg <- @errors}>{msg}</.shadow_error>
    </div>
    """
  end

  def shadow_input(%{type: "select"} = assigns) do
    ~H"""
    <div>
      <select
        id={@id}
        name={@name}
        class="mt-2 block w-full bg-zinc-900 text-zinc-200 text-[13px] rounded-md shadow-sm focus:outline-none focus:ring-0"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.shadow_error :for={msg <- @errors}>{msg}</.shadow_error>
    </div>
    """
  end

  def shadow_input(%{type: "textarea"} = assigns) do
    ~H"""
    <div class={[
      "w-full p-0 bg-transparent text-zinc-200 text-[13px] placeholder:text-zinc-500 focus:outline-none border-none focus:ring-0 min-h-[6rem] resize-none",
      @class
    ]}>
      <input id={@id} type="hidden" name={@name} value={@value} {@rest} />
      <.Editor
        content={@value}
        placeholder={@rest[:placeholder]}
        inputId={@id}
        socket={@socket}
        resourceId={@rest[:"phx-value-id"] || @rest[:"phx-value-id"] || nil}
        field={@rest[:"phx-value-field"] || @rest[:"phx-value-field"] || nil}
        blurEvent={@rest[:"phx-blur"] || @rest[:"phx-blur"] || nil}
        autosave={@autosave}
        autosaveDelay={@autosave_delay}
        streaming={@streaming}
        streamingComplete={@streaming_complete}
        isDisabled={@rest[:disabled] && !@streaming}
      />
      <.shadow_error :for={msg <- @errors}>{msg}</.shadow_error>
    </div>
    """
  end

  def shadow_input(assigns) do
    ~H"""
    <div>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={
          classes([
            "w-full p-0 bg-transparent text-zinc-200 text-[13px] placeholder:text-zinc-500 focus:outline-none border-none focus:ring-0",
            @class
          ])
        }
        {@rest}
      />
      <.shadow_error :for={msg <- @errors}>{msg}</.shadow_error>
    </div>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any
  attr :field, Phoenix.HTML.FormField
  attr :errors, :list, default: []
  attr :hint, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :on_select, :any, default: nil, doc: "Event handler for selection"
  attr :variant, :string, default: "secondary", values: ["primary", "secondary", "transparent"]
  attr :resource_id, :any, default: nil, doc: "The resource ID for the select input"

  def shadow_select_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    extra = assigns_to_attributes(assigns)

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error/1))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:field_name, fn -> field.field end)
    |> assign_new(:value, fn ->
      case field.value do
        value when is_atom(value) -> Atom.to_string(value)
        value -> value
      end
    end)
    |> assign_new(:placeholder, fn -> "Select" end)
    |> assign(
      :selected,
      Enum.find(assigns.options, fn option ->
        to_string(option.value) == to_string(assigns.value)
      end) || Enum.at(assigns.options, 0)
    )
    |> assign(:extra, extra)
    |> shadow_select_input()
  end

  def shadow_select_input(assigns) do
    ~H"""
    <div id={"#{@id}-container"} phx-feedback-for={@name}>
      <div class="relative mt-2">
        <input type="hidden" name={@name} id={"#{@id}-hidden"} value={@value} />

        <.dropdown_menu>
          <.dropdown_menu_trigger id={"#{@id}-select-dropdown-trigger"} class="group">
            <.shadow_button
              id={@id}
              aria-expanded="false"
              aria-haspopup="true"
              variant={@variant}
              disabled={@disabled}
            >
              <%= if @selected.value == nil do %>
                <span>{@prompt}</span>
              <% else %>
                <%= if Map.has_key?(@selected, :icon) do %>
                  <.icon name={@selected.icon} class={Enum.join(["size-4", @selected.color], " ")} />
                <% end %>
                <span>{@selected.label}</span>
              <% end %>
            </.shadow_button>
          </.dropdown_menu_trigger>

          <.dropdown_menu_content>
            <.menu class="w-56 text-zinc-300 bg-zinc-800">
              <.menu_group>
                <.menu_item class="pointer-events-none">
                  <span class="text-zinc-400 font-extralight tracking-tighter">
                    {@prompt}
                  </span>
                </.menu_item>
              </.menu_group>

              <.menu_separator />

              <.menu_group>
                <%= for option <- @options do %>
                  <.menu_item
                    phx-click={(@disabled && nil) || JS.push(@on_select)}
                    phx-value-id={@resource_id}
                    phx-value-field={@field_name}
                    phx-value-value={option.value}
                    class={(@disabled && "opacity-50 cursor-not-allowed") || ""}
                  >
                    <div class="w-full flex items-center gap-2">
                      <%= if Map.has_key?(option, :icon) do %>
                        <.icon name={option.icon} class={Enum.join(["size-4", option.color], " ")} />
                      <% end %>
                      <span>{option.label}</span>
                      <.menu_shortcut>
                        <div class="w-full flex items-center gap-2 justify-between">
                          <%= cond do %>
                            <% is_binary(@value) && is_binary(option.value) && option.value == @value -> %>
                              <.icon name="hero-check-solid" class="size-5 text-zinc-50" />
                            <% is_atom(@value) && is_binary(option.value) && String.to_atom(option.value) == @value -> %>
                              <.icon name="hero-check-solid" class="size-5 text-zinc-50" />
                            <% is_atom(option.value) && (option.value == @value || (is_binary(@value) && option.value == String.to_atom(@value))) -> %>
                              <.icon name="hero-check-solid" class="size-5 text-zinc-50" />
                            <% true -> %>
                              <!-- No icon -->
                          <% end %>
                          <span>{option.shortcut}</span>
                        </div>
                      </.menu_shortcut>
                    </div>
                  </.menu_item>
                <% end %>
              </.menu_group>
            </.menu>
          </.dropdown_menu_content>
        </.dropdown_menu>
      </div>
    </div>
    """
  end

  slot :inner_block, required: true

  def shadow_error(assigns) do
    ~H"""
    <p class="flex gap-2 text-xs leading-6 text-red-700">
      {render_slot(@inner_block)}
    </p>
    """
  end

  @min_date Date.utc_today() |> Date.add(-365)

  attr :id, :string, required: true
  attr :resource_id, :any, default: nil
  attr :label, :string, required: true
  attr :position, :string, default: "bottom", values: ~w(bottom left right top)

  attr :start_date_field, :any,
    doc: "a %Phoenix.HTML.Form{}/field name tuple, for example: @form[:start_date]"

  attr :min, :any, default: @min_date, doc: "the earliest date that can be set"
  attr :max, :any, default: Date.utc_today(), doc: "the latest date that can be set"

  attr :variant, :string, default: "default", values: ["default", "transparent"]

  attr :errors, :list, default: []

  attr :rest, :global, include: ~w(disabled form placeholder readonly required)

  def shadow_date_picker(assigns) do
    ~H"""
    <.live_component
      module={AccomplishWeb.Shadowrun.DatePicker}
      label={@label}
      id={@id}
      resource_id={@resource_id}
      form={@rest[:form]}
      start_date_field={@start_date_field}
      required={@rest[:required]}
      readonly={@rest[:readonly]}
      placeholder={@rest[:placeholder] || "Select date"}
      min={@min}
      max={@max}
      variant={@variant}
      position={@position}
    />
    """
  end

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :field, Phoenix.HTML.FormField, required: true
  attr :placeholder, :string, default: "Enter a URL"
  attr :form, :any, default: nil
  attr :rest, :global, default: %{}, include: ~w(disabled readonly required autocomplete)

  def shadow_url_input(assigns) do
    ~H"""
    <.live_component
      module={AccomplishWeb.Shadowrun.UrlInput}
      id={@id}
      class={@class}
      field={@field}
      form={@form}
      placeholder={@placeholder}
      {@rest}
    />
    """
  end

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :field, Phoenix.HTML.FormField, required: true
  attr :placeholder, :string, default: "Enter GitHub username"
  attr :form, :any, default: nil
  attr :rest, :global, default: %{}, include: ~w(disabled readonly required autocomplete)

  def shadow_github_input(assigns) do
    ~H"""
    <.live_component
      module={AccomplishWeb.Shadowrun.SocialHandleInput}
      id={@id}
      class={@class}
      field={@field}
      form={@form}
      platform={:github}
      placeholder={@placeholder}
      {@rest}
    />
    """
  end

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :field, Phoenix.HTML.FormField, required: true
  attr :placeholder, :string, default: "Enter LinkedIn username"
  attr :form, :any, default: nil
  attr :rest, :global, default: %{}, include: ~w(disabled readonly required autocomplete)

  def shadow_linkedin_input(assigns) do
    ~H"""
    <.live_component
      module={AccomplishWeb.Shadowrun.SocialHandleInput}
      id={@id}
      class={@class}
      field={@field}
      form={@form}
      platform={:linkedin}
      placeholder={@placeholder}
      {@rest}
    />
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def shadow_box(assigns) do
    ~H"""
    <div
      class={
        classes([
          "rounded-lg border border-solid p-4 border-zinc-700 bg-zinc-900 text-zinc-200 shadow-md",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id, :string
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string

  attr :kind, :atom,
    values: [:info, :error, :success, :warning],
    doc: "used for styling and flash lookup"

  attr :timeout, :integer,
    default: 5000,
    doc: "automatic dismiss timeout in milliseconds, 0 for no auto-dismiss"

  attr :position, :string,
    default: "bottom-right",
    values: ["bottom-right", "top-right", "bottom-left", "top-left"]

  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"
  slot :actions, doc: "slot for action buttons"

  def shadow_flash(assigns) do
    assigns =
      assigns
      |> assign(title: Phoenix.Flash.get(assigns.flash, :title) || assigns.title)
      |> assign_new(:id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      data-timeout={@timeout}
      phx-hook="Flash"
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed z-50 pointer-events-auto max-w-sm w-full shadow-lg rounded-md p-4 border border-zinc-700 transition-all duration-300 transform",
        position_class(@position),
        @kind == :info && "bg-zinc-800/60 text-zinc-200 border-blue-500/30",
        @kind == :error && "bg-zinc-800/60 text-zinc-200 border-red-500/20",
        @kind == :success && "bg-zinc-800/60 text-zinc-200 border-green-500/30",
        @kind == :warning && "bg-zinc-800/60 text-zinc-200 border-yellow-500/30"
      ]}
      {@rest}
    >
      <div class="flex items-start">
        <div class="flex-shrink-0">
          <.icon
            :if={@kind == :info}
            name="hero-information-circle-mini"
            class="h-5 w-5 text-blue-500"
          />
          <.icon
            :if={@kind == :error}
            name="hero-exclamation-circle-mini"
            class="h-5 w-5 text-red-500"
          />
          <.icon :if={@kind == :success} name="hero-check-circle-mini" class="h-5 w-5 text-green-500" />
          <.icon
            :if={@kind == :warning}
            name="hero-exclamation-triangle-mini"
            class="h-5 w-5 text-yellow-500"
          />
        </div>
        <div class="ml-3 w-0 flex-1">
          <p :if={@title} class="text-sm font-normal text-zinc-200">
            {@title}
          </p>
          <p class="text-sm text-zinc-300 font-extralight mt-1">{msg}</p>
        </div>
        <div class="ml-4 flex-shrink-0 flex">
          <button
            type="button"
            class="bg-transparent rounded-md inline-flex text-zinc-400 hover:text-zinc-200 focus:outline-none"
          >
            <span class="sr-only">Close</span>
            <.icon name="hero-x-mark-solid" class="h-4 w-4" />
          </button>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and styling.

  ## Examples

      <.shadow_flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  attr :position, :string,
    default: "bottom-right",
    values: ["bottom-right", "top-right", "bottom-left", "top-left"]

  def shadow_flash_group(assigns) do
    ~H"""
    <div id={@id} class={flash_group_position_class(@position)}>
      <.shadow_flash kind={:info} title="Information" flash={@flash} position={@position} />
      <.shadow_flash kind={:success} title="Success" flash={@flash} position={@position} />
      <.shadow_flash kind={:warning} title="Warning" flash={@flash} position={@position} />
      <.shadow_flash kind={:error} title="Error" flash={@flash} position={@position} />
      <.shadow_flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        position={@position}
        phx-disconnected={show(".phx-client-error #client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.shadow_flash>

      <.shadow_flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        position={@position}
        phx-disconnected={show(".phx-server-error #server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        {gettext("Hang in there while we get back on track")}
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.shadow_flash>
    </div>
    """
  end

  defp position_class("top-right"), do: "top-4 right-4"
  defp position_class("top-left"), do: "top-4 left-4"
  defp position_class("bottom-left"), do: "bottom-4 left-4"
  defp position_class("bottom-right"), do: "bottom-4 right-4"

  defp flash_group_position_class("top-right"),
    do: "fixed z-50 top-4 right-4 flex flex-col gap-3 w-auto max-w-sm"

  defp flash_group_position_class("top-left"),
    do: "fixed z-50 top-4 left-4 flex flex-col gap-3 w-auto max-w-sm"

  defp flash_group_position_class("bottom-left"),
    do: "fixed z-50 bottom-4 left-4 flex flex-col gap-3 w-auto max-w-sm"

  defp flash_group_position_class("bottom-right"),
    do: "fixed z-50 bottom-4 right-4 flex flex-col gap-3 w-auto max-w-sm"
end
