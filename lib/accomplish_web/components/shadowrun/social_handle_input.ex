defmodule AccomplishWeb.Shadowrun.SocialHandleInput do
  @moduledoc false

  use Phoenix.LiveComponent
  import AccomplishWeb.ShadowrunComponents
  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    has_value = not is_nil(assigns.value) && assigns.value != ""
    assigns = Map.put(assigns, :has_value, has_value)

    ~H"""
    <div class="social-handle-input">
      <input type="hidden" name={@field.name} id={"#{@id}_#{@field.id}"} value={@field.value} />

      <div class="relative group">
        <%= if @has_value && !@edit_mode do %>
          <div class="flex items-center gap-1">
            <span
              phx-click={
                JS.push("toggle-edit-mode", target: @myself)
                |> JS.dispatch("url-input:focus", to: "##{@id}")
              }
              class={[
                "cursor-pointer underline text-[13px] truncate max-w-[250px]",
                @class
              ]}
              tabindex="0"
            >
              {@field.value}
            </span>
            <a
              href={social_profile_url(@platform, @field.value)}
              target="_blank"
              rel="noopener noreferrer"
              class="text-zinc-500 self-center"
            >
              <%= if @platform == :github do %>
                <.lucide_icon name="github" class="size-3 inline-block align-middle" />
              <% else %>
                <.lucide_icon name="linkedin" class="size-3 inline-block align-middle" />
              <% end %>
            </a>
          </div>
        <% else %>
          <div id={"#{@id}"} phx-hook="UrlInputAutoFocus" phx-update="ignore">
            <input
              type="text"
              id={"#{@id}_input"}
              phx-blur="save-value"
              phx-keydown="handle-keydown"
              phx-target={@myself}
              value={@field.value}
              placeholder={@placeholder}
              class={[
                "w-full p-0 bg-transparent text-zinc-200 text-[13px] placeholder:text-zinc-500 focus:outline-none border-none focus:ring-0",
                @class
              ]}
              data-autofocus={@edit_mode}
              {Map.to_list(@rest)}
            />
          </div>
        <% end %>
      </div>

      <p class="flex gap-2 text-xs leading-6 text-red-700">
        <%= for msg <- @field.errors do %>
          {format_error(msg)}
        <% end %>
      </p>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, edit_mode: false, value: nil)}
  end

  @impl true
  def update(assigns, socket) do
    value = assigns.field.value
    assigns = Map.put_new(assigns, :rest, %{})
    edit_mode = if is_nil(value) || value == "", do: true, else: socket.assigns.edit_mode

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:edit_mode, edit_mode)
     |> assign(:value, value)}
  end

  @impl true
  def handle_event("toggle-edit-mode", _, socket) do
    {:noreply, assign(socket, edit_mode: true)}
  end

  @impl true
  def handle_event("save-value", %{"value" => value}, socket) do
    updated_socket = update_field_value(socket, value)
    edit_mode = if is_nil(value) || value == "", do: true, else: false
    {:noreply, assign(updated_socket, edit_mode: edit_mode)}
  end

  @impl true
  def handle_event("handle-keydown", %{"key" => "Enter"} = params, socket) do
    value = params["value"] || ""
    updated_socket = update_field_value(socket, value)
    edit_mode = if is_nil(value) || value == "", do: true, else: false
    {:noreply, assign(updated_socket, edit_mode: edit_mode)}
  end

  @impl true
  def handle_event("handle-keydown", _params, socket) do
    {:noreply, socket}
  end

  defp update_field_value(socket, value) do
    normalized_value = extract_handle(value, socket.assigns.platform)
    socket = assign(socket, value: normalized_value)

    send(self(), %{
      id: socket.assigns.id,
      field: socket.assigns.field.field,
      value: normalized_value,
      form: socket.assigns.form
    })

    socket
  end

  defp extract_handle("", _platform), do: ""
  defp extract_handle(nil, _platform), do: ""

  defp extract_handle(input, :github) do
    cond do
      String.match?(input, ~r{^(?:https?://)?github\.com/([^/]+)/?.*$}) ->
        Regex.run(~r{^(?:https?://)?github\.com/([^/]+)/?.*$}, input, capture: :all_but_first)
        |> List.first()

      String.starts_with?(input, "@") ->
        String.replace_prefix(input, "@", "")

      true ->
        input
    end
  end

  defp extract_handle(input, :linkedin) do
    cond do
      String.match?(input, ~r{^(?:https?://)?(?:www\.)?linkedin\.com/in/([^/]+)/?.*$}) ->
        Regex.run(~r{^(?:https?://)?(?:www\.)?linkedin\.com/in/([^/]+)/?.*$}, input,
          capture: :all_but_first
        )
        |> List.first()

      String.starts_with?(input, "@") ->
        String.replace_prefix(input, "@", "")

      true ->
        input
    end
  end

  defp social_profile_url(:github, handle) do
    "https://github.com/#{handle}"
  end

  defp social_profile_url(:linkedin, handle) do
    "https://www.linkedin.com/in/#{handle}"
  end

  defp format_error({_key, {msg, _type}}), do: msg
  defp format_error({msg, _type}), do: msg
end
