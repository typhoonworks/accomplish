defmodule AccomplishWeb.CoverLetterLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.CoverLetters
  alias Accomplish.CoverLetters.Generator
  alias Accomplish.Streaming

  import AccomplishWeb.StringHelpers
  import AccomplishWeb.CoverLetterHelpers

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Tooltip
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header>
          <:title>
            <div class="flex lg:items-center lg:gap-1">
              <.link
                href={~p"/job_application/#{@application.slug}/documents"}
                class="hidden lg:inline"
              >
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
            <.dropdown_menu>
              <.dropdown_menu_trigger id="resume-dropdown-trigger" class="group">
                <.shadow_button type="button" variant="transparent">
                  <.lucide_icon name="ellipsis" class="size-5 text-zinc-400" />
                </.shadow_button>
              </.dropdown_menu_trigger>
              <.dropdown_menu_content>
                <.menu class="w-56 text-zinc-300 bg-zinc-800">
                  <.menu_group>
                    <.menu_item class="text-sm">
                      <button
                        type="button"
                        phx-click="delete_cover_letter"
                        phx-value-id={@cover_letter.id}
                        class="flex items-center gap-2"
                      >
                        <.lucide_icon name="trash-2" class="size-4 text-zinc-400" />
                        <span>Delete cover letter</span>
                      </button>
                      <.menu_shortcut>⌘D</.menu_shortcut>
                    </.menu_item>
                  </.menu_group>
                </.menu>
              </.dropdown_menu_content>
            </.dropdown_menu>
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
            />
            <.tooltip_content side="bottom">
              <p>Change status</p>
            </.tooltip_content>
          </.tooltip>

          <.tooltip :if={!@ai_writing}>
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
            streaming={@ai_writing}
            streaming_complete={@ai_writing_complete}
          />
        </div>
      </section>
    </.layout>
    """
  end

  def mount(
        %{"application_slug" => application_slug, "id" => id, "ai_generate" => "true"},
        _session,
        socket
      ) do
    applicant = socket.assigns.current_user

    with {:ok, application} <-
           JobApplications.get_application_by_slug(applicant, application_slug),
         cover_letter <- CoverLetters.get_application_cover_letter!(application, id) do
      stream_id = "cover_letter_stream_#{cover_letter.id}"

      socket =
        socket
        |> assign(page_title: cover_letter.title)
        |> assign(application: application)
        |> assign(cover_letter: cover_letter)
        |> assign_form(cover_letter)
        |> assign(is_saving: false)
        |> assign(autosave: true)
        |> assign(:ai_writing, false)
        |> assign(:ai_writing_complete, false)
        |> assign(stream_id: stream_id)

      Generator.start_stream(applicant, application, cover_letter.id)
      updated_socket = check_and_connect_to_stream(socket)

      {:ok, updated_socket}
    else
      :error -> {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  def mount(%{"application_slug" => application_slug, "id" => id}, _session, socket) do
    applicant = socket.assigns.current_user

    with {:ok, application} <-
           JobApplications.get_application_by_slug(applicant, application_slug),
         cover_letter <- CoverLetters.get_application_cover_letter!(application, id) do
      stream_id = "cover_letter_stream_#{cover_letter.id}"

      socket =
        socket
        |> assign(page_title: cover_letter.title)
        |> assign(application: application)
        |> assign(cover_letter: cover_letter)
        |> assign_form(cover_letter)
        |> assign(is_saving: false)
        |> assign(autosave: true)
        |> assign(stream_id: stream_id)
        |> assign(:ai_writing, false)
        |> assign(:ai_writing_complete, false)

      updated_socket = check_and_connect_to_stream(socket)

      {:ok, updated_socket}
    else
      :error -> {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  def handle_event("save_field", %{"field" => field, "value" => value}, socket) do
    if socket.assigns.ai_writing do
      {:noreply, socket}
    else
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
  end

  def handle_event("generate_cover_letter", _params, socket) do
    if socket.assigns.ai_writing do
      {:noreply, socket}
    else
      application = socket.assigns.application
      cover_letter = socket.assigns.cover_letter
      user = socket.assigns.current_user

      {:ok, _stream_id} = Generator.start_stream(user, application, cover_letter.id)
      {:noreply, check_and_connect_to_stream(socket)}
    end
  end

  def handle_event("delete_cover_letter", %{"id" => id}, socket) do
    application = socket.assigns.application

    case CoverLetters.delete_cover_letter(application, id) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Cover letter deleted successfully.")
         |> push_navigate(to: ~p"/job_application/#{application.slug}/documents")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete cover letter.")}
    end
  end

  def handle_info(:saved, socket) do
    {:noreply, assign(socket, :is_saving, false)}
  end

  def handle_info({:stream_buffer, buffer}, socket) do
    form = socket.assigns.form

    updated_form =
      Map.update!(form, :params, fn params ->
        Map.put(params, "content", buffer)
      end)

    {:noreply, assign(socket, form: updated_form)}
  end

  def handle_info({:stream_chunk, _chunk}, socket) do
    {:noreply, socket}
  end

  def handle_info({:stream_complete, _final_buffer}, socket) do
    {:noreply,
     socket
     |> assign(:ai_writing, false)
     |> assign(:ai_writing_complete, true)
     |> put_flash(:info, "Cover letter written by AI")}
  end

  def handle_info({:stream_status, status}, socket) do
    case status do
      :streaming ->
        {:noreply, assign(socket, ai_writing: true, ai_writing_complete: false)}

      :completed ->
        {:noreply, assign(socket, ai_writing: false, ai_writing_complete: true)}

      :stopped ->
        {:noreply, assign(socket, ai_writing: false, ai_writing_complete: false)}
    end
  end

  defp assign_form(socket, cover_letter) do
    form = CoverLetters.change_cover_letter(cover_letter)
    assign(socket, form: to_form(form))
  end

  defp check_and_connect_to_stream(socket) do
    stream_id = socket.assigns.stream_id

    case Streaming.Manager.get_stream(stream_id) do
      {:ok, stream_pid} ->
        Streaming.Manager.register_consumer(stream_pid, self())

        status = Streaming.Manager.get_status(stream_pid)
        is_writing = status == :streaming

        socket
        |> assign(:ai_writing, is_writing)
        |> assign(:ai_writing_complete, status == :completed)

      :not_found ->
        socket
    end
  end
end
