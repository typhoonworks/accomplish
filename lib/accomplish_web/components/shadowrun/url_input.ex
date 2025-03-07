defmodule AccomplishWeb.Shadowrun.UrlInput do
  @moduledoc false

  use Phoenix.LiveComponent
  import AccomplishWeb.CoreComponents
  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    has_value = not is_nil(assigns.value) && assigns.value != ""
    assigns = Map.put(assigns, :has_value, has_value)

    ~H"""
    <div class="url-input">
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
            >
              {@field.value}
            </span>
            <a
              href={fix_url(@field.value)}
              target="_blank"
              rel="noopener noreferrer"
              class="text-zinc-500 self-center"
            >
              <.icon
                name="hero-arrow-top-right-on-square-mini"
                class="size-3 inline-block align-middle"
              />
            </a>
          </div>
        <% else %>
          <div id={"#{@id}"} phx-hook="UrlInputAutoFocus" phx-update="ignore">
            <input
              type="url"
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
    normalized_value = normalize_url(value)
    socket = assign(socket, value: normalized_value)

    send(self(), %{
      id: socket.assigns.id,
      field: socket.assigns.field.field,
      value: normalized_value,
      form: socket.assigns.form
    })

    socket
  end

  defp normalize_url(""), do: ""
  defp normalize_url(nil), do: ""

  defp normalize_url(url) do
    if String.starts_with?(url, ["http://", "https://"]) do
      url
    else
      "https://#{url}"
    end
  end

  defp fix_url(url) do
    normalize_url(url)
  end

  defp format_error({_key, {msg, _type}}), do: msg
  defp format_error({msg, _type}), do: msg
end
