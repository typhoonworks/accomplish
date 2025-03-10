defmodule AccomplishWeb.CoverLetterLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.CoverLetters
  alias Accomplish.CoverLetters.Generator

  import AccomplishWeb.StringHelpers
  import AccomplishWeb.CoverLetterHelpers
  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Tooltip

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header>
          <:title>
            <div class="flex lg:items-center lg:gap-1">
              <.link href={~p"/job_application/#{@application.slug}/stages"} class="hidden lg:inline">
                <span class="inline">{@application.role} at {@application.company.name}</span>
              </.link>
              <span class="hidden lg:inline-flex items-center text-zinc-400">
                <.icon name="hero-chevron-right" class="size-3" />
              </span>
              <span class="inline">
                {truncate(@cover_letter.title, length: 20)}
              </span>
            </div>
          </:title>

          <:menu>
            <%= if @ai_writing do %>
              <div class="flex items-center gap-2">
                <.lucide_icon name="sparkles" class="animate-pulse h-5 w-5 text-purple-500" />
                <p class="text-zinc-300 text-sm">AI writing...</p>
              </div>
            <% else %>
              <.saving_indicator is_saving={@is_saving} />
            <% end %>
          </:menu>
        </.page_header>
      </:page_header>

      <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
        <div class="space-y-4 mb-6">
          <.shadow_input
            field={@form[:title]}
            placeholder="Cover letter title"
            class="text-[25px] tracking-tighter hover:cursor-text"
            phx-blur="save_field"
            phx-value-field={@form[:title].field}
            disabled={@ai_writing}
          />
        </div>
        <div class="flex justify-start items-baseline gap-2 my-2">
          <.tooltip>
            <.shadow_select_input
              id={"status_select_#{@form.id}"}
              field={@form[:status]}
              prompt="Change status"
              value={@form[:status].value}
              options={options_for_cover_letter_status()}
              on_select="save_field"
              variant="transparent"
              disabled={@ai_writing}
            />
            <.tooltip_content side="bottom">
              <p>Change status</p>
            </.tooltip_content>
          </.tooltip>

          <.tooltip :if={!@ai_writing && !@ai_writing_complete}>
            <button
              phx-click="generate_cover_letter"
              class="flex items-center gap-1 px-2.5 py-1 rounded-md text-xs font-light transition-colors duration-150 hover:bg-zinc-800 text-zinc-300"
            >
              <.lucide_icon name="sparkles" class="size-4 text-purple-400" />
              <span>AI Write</span>
            </button>
            <.tooltip_content side="bottom">
              <p>Let AI write this cover letter</p>
            </.tooltip_content>
          </.tooltip>
        </div>
        <div class="mt-12 space-y-2">
          <.shadow_input
            field={@form[:content]}
            type="textarea"
            placeholder="Highlight your skills, experience, and passion for this role..."
            class="text-[14px] font-light hover:cursor-text"
            socket={@socket}
            phx-blur="save_field"
            phx-value-field={@form[:content].field}
            autosave={@autosave && !@ai_writing}
            autosave_delay={2000}
            disabled={@ai_writing}
          />
        </div>

        <%= if @ai_writing do %>
          <div class="mt-6 flex flex-col gap-4">
            <div class="flex justify-between items-center">
              <div class="flex items-center gap-2">
                <.lucide_icon name="sparkles" class="animate-pulse h-5 w-5 text-purple-500" />
                <p class="text-zinc-300 text-sm">Writing your cover letter...</p>
              </div>
              <div class="typing-indicator">
                <span></span>
                <span></span>
                <span></span>
              </div>
            </div>
            <div id="live-content" class="text-sm leading-relaxed text-zinc-300 font-serif max-w-3xl">
              {@ai_content}<span class="cursor animate-pulse">|</span>
            </div>
          </div>
        <% end %>
      </section>
    </.layout>
    """
  end

  def mount(
        %{"application_slug" => application_slug, "id" => id},
        %{"ai_generate" => "true"} = _session,
        socket
      ) do
    applicant = socket.assigns.current_user

    with {:ok, application} <-
           JobApplications.get_application_by_slug(applicant, application_slug),
         cover_letter <- CoverLetters.get_application_cover_letter!(application, id) do
      # Start AI generation immediately
      Generator.generate_streaming(self(), applicant, application)

      socket =
        socket
        |> assign(page_title: cover_letter.title)
        |> assign(application: application)
        |> assign(cover_letter: cover_letter)
        |> assign(autosave: true)
        |> assign(is_saving: false)
        |> assign(ai_writing: true)
        |> assign(ai_writing_complete: false)
        |> assign(ai_content: "")
        |> assign_form(cover_letter)

      {:ok, socket}
    else
      :error -> {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  def mount(%{"application_slug" => application_slug, "id" => id}, _session, socket) do
    applicant = socket.assigns.current_user

    with {:ok, application} <-
           JobApplications.get_application_by_slug(applicant, application_slug),
         cover_letter <- CoverLetters.get_application_cover_letter!(application, id) do
      socket =
        socket
        |> assign(page_title: cover_letter.title)
        |> assign(application: application)
        |> assign(cover_letter: cover_letter)
        |> assign(autosave: true)
        |> assign(is_saving: false)
        |> assign(ai_writing: false)
        |> assign(ai_writing_complete: false)
        |> assign(ai_content: "")
        |> assign_form(cover_letter)

      {:ok, socket}
    else
      :error -> {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  def handle_event("save_field", %{"field" => field, "value" => value}, socket) do
    cover_letter = socket.assigns.cover_letter
    changes = %{field => value}

    socket = assign(socket, :is_saving, true)

    case CoverLetters.update_cover_letter(cover_letter, changes) do
      {:ok, updated_cover_letter} ->
        form =
          updated_cover_letter
          |> CoverLetters.change_cover_letter()
          |> to_form()

        Process.send_after(self(), :saved, 500)

        {:noreply,
         socket
         |> assign(form: form)
         |> assign(cover_letter: updated_cover_letter)}

      {:error, _changeset} ->
        Process.send_after(self(), :saved, 500)
        {:noreply, socket}
    end
  end

  def handle_event("generate_cover_letter", _params, socket) do
    application = socket.assigns.application
    user = socket.assigns.current_user

    # Start the cover letter generation process
    Generator.generate_streaming(self(), user, application)

    {:noreply,
     socket
     |> assign(ai_writing: true)
     |> assign(ai_content: "")}
  end

  def handle_info(:saved, socket) do
    {:noreply, assign(socket, :is_saving, false)}
  end

  # Handle Anthropix streaming messages
  def handle_info({_pid, {:data, %{"type" => type} = message}}, socket) do
    case type do
      "content_block_delta" ->
        if is_map_key(message, "delta") and is_map_key(message["delta"], "text") do
          new_content = socket.assigns.ai_content <> message["delta"]["text"]

          {:noreply, assign(socket, :ai_content, new_content)}
        else
          {:noreply, socket}
        end

      "message_stop" ->
        # Generation complete, update the cover letter content
        {:noreply, complete_ai_generation(socket)}

      _ ->
        # Ignore other message types
        {:noreply, socket}
    end
  end

  # Handle direct message format (used in legacy/testing mode)
  def handle_info(%{"type" => type} = message, socket) do
    case type do
      "content_block_delta" ->
        if is_map_key(message, "delta") and is_map_key(message["delta"], "text") do
          new_content = socket.assigns.ai_content <> message["delta"]["text"]

          {:noreply, assign(socket, :ai_content, new_content)}
        else
          {:noreply, socket}
        end

      "message_stop" ->
        # Generation complete, update the cover letter content
        {:noreply, complete_ai_generation(socket)}

      _ ->
        # Ignore other message types
        {:noreply, socket}
    end
  end

  def handle_info({:stream_error, error}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "Error generating cover letter: #{error}")
     |> assign(:ai_writing, false)}
  end

  defp complete_ai_generation(socket) do
    cover_letter = socket.assigns.cover_letter

    # Update the cover letter with the AI-generated content
    case CoverLetters.update_cover_letter(cover_letter, %{content: socket.assigns.ai_content}) do
      {:ok, updated_cover_letter} ->
        form =
          updated_cover_letter
          |> CoverLetters.change_cover_letter()
          |> to_form()

        socket
        |> assign(ai_writing: false)
        |> assign(ai_writing_complete: true)
        |> assign(form: form)
        |> assign(cover_letter: updated_cover_letter)
        |> put_flash(:info, "Cover letter written by AI")

      {:error, _changeset} ->
        socket
        |> assign(ai_writing: false)
        |> put_flash(:error, "Failed to save AI-generated cover letter")
    end
  end

  defp assign_form(socket, cover_letter) do
    form = CoverLetters.change_cover_letter(cover_letter)
    assign(socket, form: to_form(form))
  end
end
