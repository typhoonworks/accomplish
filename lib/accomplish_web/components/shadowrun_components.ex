defmodule AccomplishWeb.ShadowrunComponents do
  @moduledoc false

  use Phoenix.Component
  use LiveSvelte.Components

  use Gettext, backend: AccomplishWeb.Gettext

  alias Phoenix.LiveView.JS

  import AccomplishWeb.CoreComponents
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu

  attr :type, :string, default: "button"
  attr :variant, :string, default: "primary", values: ["primary", "secondary"]
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
        <.icon
          name={@icon}
          class="size-4 shrink-0 group-hover:scale-110 group-hover:text-zinc-50 text-current"
        />
      <% end %>
      <span>{@text}</span>
    </.link>
    """
  end

  attr :id, :any, default: nil

  def separator(assigns) do
    ~H"""
    <div role="separator" id={@id} class="relative -mx-1 h-px bg-zinc-700"></div>
    """
  end

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
    values: ~w(checkbox color date datetime-local email file month number password
               range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :socket, :any

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

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
    <div class="w-full p-0 bg-transparent text-zinc-200 text-[13px] placeholder:text-zinc-500 focus:outline-none border-none focus:ring-0 min-h-[6rem] resize-none">
      <input id={@id} type="hidden" name={@name} value={@value} {@rest} />
      <.Editor
        :if={!@rest[:disabled]}
        content={@value}
        placeholder={@rest[:placeholder]}
        inputId={@id}
        socket={@socket}
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
        class={[
          "w-full p-0 bg-transparent text-zinc-200 text-[13px] placeholder:text-zinc-500 focus:outline-none border-none focus:ring-0",
          @class
        ]}
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
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :on_select, :any, default: nil, doc: "Event handler for selection"

  def shadow_select_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error/1))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn ->
      case field.value do
        value when is_atom(value) -> Atom.to_string(value)
        value -> value
      end
    end)
    |> assign(
      :selected,
      Enum.find(assigns.options, fn option ->
        to_string(option.value) == to_string(assigns.value)
      end) || Enum.at(assigns.options, 0)
    )
    |> shadow_select_input()
  end

  def shadow_select_input(assigns) do
    ~H"""
    <div id={"#{@id}-container"} phx-feedback-for={@name}>
      <div class="relative mt-2">
        <input type="hidden" name={@name} id={"#{@id}-hidden"} value={@value} />

        <.dropdown_menu>
          <.dropdown_menu_trigger class="group">
            <.shadow_button id={@id} aria-expanded="false" aria-haspopup="true" variant="secondary">
              <%= if Map.has_key?(@selected, :icon) do %>
                <.icon name={@selected.icon} class={["size-4", @selected.color]} />
              <% end %>
              <span>{@selected.label}</span>
            </.shadow_button>
          </.dropdown_menu_trigger>

          <.dropdown_menu_content>
            <.menu class="w-56 text-zinc-300 bg-zinc-800">
              <.menu_group>
                <.menu_item>
                  <span class="text-zinc-400 font-extralight tracking-tighter">
                    {@prompt}
                  </span>
                </.menu_item>
              </.menu_group>

              <.menu_separator />

              <.menu_group>
                <%= for option <- @options do %>
                  <.menu_item
                    phx-click={JS.push(@on_select)}
                    phx-value-value={option.value}
                    class="hover:bg-zinc-600 rounded-md"
                  >
                    <div class="w-full flex items-center gap-2">
                      <%= if Map.has_key?(option, :icon) do %>
                        <.icon name={option.icon} class={["size-4", option.color]} />
                      <% end %>
                      <span>{option.label}</span>
                      <.menu_shortcut>
                        <div class="w-full flex items-center gap-2 justify-between">
                          <%= if option.value == @value do %>
                            <.icon name="hero-check-solid" class="size-5 text-zinc-50" />
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
end
