defmodule AccomplishWeb.Components.CoverLetterGenerator do
  @moduledoc false

  use Phoenix.LiveComponent
  import AccomplishWeb.ShadowrunComponents
  import AccomplishWeb.Shadowrun.Dialog

  def render(assigns) do
    ~H"""
    <div class="cover-letter-generator" id="clipboard-hook" phx-hook="Clipboard">
      <.dialog_content id="cover-letter-content" class="pb-6">
        <div :if={@state == :idle} class="flex flex-col gap-4 py-4">
          <p class="text-zinc-300 text-sm">
            I'll create a personalized cover letter for your application to
            <span class="font-semibold">{@application.role}</span>
            at <span class="font-semibold"><%= @application.company.name %></span>.
          </p>
          <p class="text-zinc-300 text-sm">
            The letter will be tailored based on your profile information and the job details.
          </p>
        </div>

        <div :if={@state == :generating} class="flex flex-col gap-4 py-4">
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-2">
              <.lucide_icon name="sparkles" class="animate-pulse h-5 w-5 text-purple-500" />
              <p class="text-zinc-300 text-sm">Writing your custom cover letter...</p>
            </div>
            <div class="typing-indicator">
              <span></span>
              <span></span>
              <span></span>
            </div>
          </div>

          <div class="p-4 text-sm leading-relaxed text-zinc-300 whitespace-pre-wrap max-h-[60vh] overflow-y-auto font-serif letter-content">
            {@streamed_content}
            <span class="cursor animate-pulse">|</span>
          </div>
        </div>

        <div :if={@state == :complete} class="flex flex-col gap-4 py-4">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-zinc-200 font-medium">Your Cover Letter</h3>
            <div class="flex gap-2">
              <.shadow_button variant="transparent" phx-click="copy_to_clipboard" phx-target={@myself}>
                <.lucide_icon name="copy" class="size-4 mr-1" /> Copy
              </.shadow_button>
              <.shadow_button variant="transparent" phx-click="regenerate" phx-target={@myself}>
                <.lucide_icon name="refresh-cw" class="size-4 mr-1" /> Regenerate
              </.shadow_button>
            </div>
          </div>

          <div class="p-4 text-sm leading-relaxed text-zinc-300 whitespace-pre-wrap max-h-[60vh] overflow-y-auto font-serif letter-content">
            {@streamed_content}
          </div>
        </div>

        <div :if={@state == :error} class="flex flex-col gap-4 py-4">
          <div class="bg-red-900/30 border border-red-700 rounded-md p-4 text-red-200">
            <div class="flex items-center gap-2 mb-2">
              <.lucide_icon name="alert-triangle" class="h-5 w-5 text-red-400" />
              <h3 class="font-medium">Error generating cover letter</h3>
            </div>
            <p class="text-sm mb-4">
              There was a problem generating your cover letter. Please try again.
            </p>
            <p class="text-xs font-mono bg-red-950/30 p-2 rounded">
              {@error}
            </p>
          </div>
        </div>
      </.dialog_content>

      <.dialog_footer>
        <div class="flex justify-end gap-2">
          <.shadow_button
            type="button"
            variant="secondary"
            phx-click="close_dialog"
            phx-target={@myself}
          >
            {if @state == :complete, do: "Close", else: "Cancel"}
          </.shadow_button>

          <.shadow_button
            :if={@state == :idle}
            type="button"
            variant="primary"
            phx-click="generate_cover_letter"
            phx-target={@myself}
          >
            Generate
          </.shadow_button>

          <.shadow_button
            :if={@state == :error}
            type="button"
            variant="primary"
            phx-click="generate_cover_letter"
            phx-target={@myself}
          >
            Try Again
          </.shadow_button>

          <.shadow_button
            :if={@state == :complete}
            type="button"
            variant="primary"
            phx-click="save_draft"
            phx-target={@myself}
          >
            Save as Draft
          </.shadow_button>
        </div>
      </.dialog_footer>
    </div>
    """
  end

  def mount(socket) do
    {:ok,
     socket
     |> assign(:state, :idle)
     |> assign(:streamed_content, "")
     |> assign(:error, nil)}
  end

  def update(assigns, socket) do
    # Always merge basic props
    socket = assign(socket, Map.take(assigns, [:application, :id, :myself]))

    cond do
      # Handle content streaming
      Map.has_key?(assigns, :content) && is_binary(assigns.content) ->
        {:ok,
         assign(socket, :streamed_content, socket.assigns.streamed_content <> assigns.content)}

      # Handle completion of generation
      Map.has_key?(assigns, :complete) && assigns.complete ->
        {:ok, assign(socket, :state, :complete)}

      # Handle error state
      Map.has_key?(assigns, :error) && assigns.error ->
        {:ok,
         socket
         |> assign(:error, assigns.error)
         |> assign(:state, :error)}

      # Normal update
      true ->
        {:ok, socket}
    end
  end

  def handle_event("generate_cover_letter", _params, socket) do
    send(self(), {:start_cover_letter_generation, socket.assigns.application.id})

    {:noreply,
     socket
     |> assign(:state, :generating)
     |> assign(:streamed_content, "")}
  end

  def handle_event("regenerate", _params, socket) do
    send(self(), {:start_cover_letter_generation, socket.assigns.application.id})

    {:noreply,
     socket
     |> assign(:state, :generating)
     |> assign(:streamed_content, "")}
  end

  def handle_event("close_dialog", _params, socket) do
    send(self(), {:close_cover_letter_dialog})
    {:noreply, socket}
  end

  def handle_event("copy_to_clipboard", _params, socket) do
    {:noreply,
     socket
     |> push_event("copy-to-clipboard", %{text: socket.assigns.streamed_content})}
  end

  def handle_event("save_draft", _params, socket) do
    # In the future, this would save the cover letter to the database
    send(self(), {:close_cover_letter_dialog})
    {:noreply, socket}
  end

  # Handle Anthropix streaming messages
  def handle_info(%{"type" => type} = message, socket) do
    case type do
      "content_block_delta" ->
        if is_map_key(message, "delta") and is_map_key(message["delta"], "text") do
          {:noreply,
           assign(
             socket,
             :streamed_content,
             socket.assigns.streamed_content <> message["delta"]["text"]
           )}
        else
          {:noreply, socket}
        end

      "message_stop" ->
        {:noreply, assign(socket, :state, :complete)}

      _ ->
        # Ignore other message types
        {:noreply, socket}
    end
  end

  def handle_info({:stream_error, error}, socket) do
    {:noreply,
     socket
     |> assign(:error, error)
     |> assign(:state, :error)}
  end
end
