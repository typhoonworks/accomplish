defmodule AccomplishWeb.ResumeLive.ResumeHeader do
  use AccomplishWeb, :live_view

  alias Accomplish.Workers.ExtractResumeData

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu

  @pubsub Accomplish.PubSub

  def render(assigns) do
    ~H"""
    <.page_header page_title="Resume">
      <:views>
        <.nav_button
          icon="file-text"
          text="Overview"
          href={~p"/resume/overview"}
          active={@view == :overview}
        />
        <.nav_button
          icon="laptop"
          text="Experience"
          href={~p"/resume/experience"}
          active={@view == :experience}
        />
        <.nav_button
          icon="graduation-cap"
          text="Education"
          href={~p"/resume/education"}
          active={@view == :education}
        />
      </:views>
      <:actions>
        <.shadow_button phx-click="import_resume" variant="transparent" class="text-xs">
          <.icon name="hero-plus" class="size-3" /> Import Resume
        </.shadow_button>
      </:actions>
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
                <.menu_item class="text-xs">
                  <button type="button" phx-click="import_resume" class="flex items-center gap-2">
                    <.lucide_icon name="file-text" class="size-4 text-zinc-400" />
                    <span>Import Resume</span>
                  </button>
                  <.menu_shortcut>⌘I</.menu_shortcut>
                </.menu_item>
              </.menu_group>
            </.menu>
          </.dropdown_menu_content>
        </.dropdown_menu>
        <.saving_indicator is_saving={@is_saving} />
      </:menu>
    </.page_header>

    {render_import_resume_dialog(assigns)}
    """
  end

  def render_import_resume_dialog(assigns) do
    ~H"""
    <.dialog
      id="import-resume-dialog"
      position={:center}
      on_cancel={hide_modal("import-resume-dialog")}
      class="w-full max-w-md"
    >
      <.dialog_header>
        <.dialog_title class="text-sm text-zinc-200 font-light">
          <div class="flex items-center gap-2">
            <.icon name="hero-document-text" class="size-4" />
            <p>Import Resume</p>
          </div>
        </.dialog_title>
        <.dialog_description>
          Upload your resume PDF to automatically import your profile information.
          <span class="text-red-400">This will overwrite existing profile data.</span>
        </.dialog_description>
      </.dialog_header>

      <.form
        for={@resume_upload_form}
        id="resume-upload-form"
        phx-submit="import_resume_file"
        phx-change="validate_resume_file"
        class="space-y-4"
      >
        <.dialog_content id="import-resume-content">
          <div class="flex flex-col gap-4 py-2">
            <.live_file_input
              upload={@uploads.resume}
              class="block w-full text-sm text-zinc-400
              file:mr-4 file:py-2 file:px-4
              file:rounded-md file:border-0
              file:text-xs file:font-light
              file:bg-zinc-700 file:text-zinc-200
              hover:file:bg-zinc-600"
            />

            <div :if={Enum.any?(@uploads.resume.errors)} class="text-red-500 text-xs">
              <%= for {_ref, error} <- @uploads.resume.errors do %>
                <p>{error_to_string(error)}</p>
              <% end %>
            </div>
          </div>
        </.dialog_content>

        <.dialog_footer>
          <div class="flex justify-end gap-2">
            <.shadow_button
              type="button"
              variant="secondary"
              phx-click={hide_dialog("import-resume-dialog")}
            >
              Cancel
            </.shadow_button>
            <.shadow_button
              type="submit"
              variant="primary"
              phx-disable-with="Uploading..."
              disabled={@uploads.resume.entries == []}
            >
              Import
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.form>
    </.dialog>
    """
  end

  on_mount {AccomplishWeb.Plugs.UserAuth, :mount_current_user}

  def mount(_params, %{"view" => view, "topic" => topic}, socket) do
    socket =
      socket
      |> assign(:view, view)
      |> assign_uploads()
      |> assign(:resume_upload_form, to_form(%{"file" => nil}))
      |> assign(:is_saving, false)
      |> subscribe_to_parent_topic(topic)

    {:ok, socket}
  end

  def handle_info({:set_saving, value}, socket) do
    {:noreply, assign(socket, is_saving: value)}
  end

  def handle_event("import_resume", _params, socket) do
    resume_upload_form = to_form(%{"file" => nil})

    {:noreply,
     socket
     |> assign(:resume_upload_form, resume_upload_form)
     |> push_event("js-exec", %{
       to: "#import-resume-dialog",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("validate_resume_file", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("import_resume_file", _params, socket) do
    consume_uploaded_entries(socket, :resume, fn %{path: path}, _entry ->
      case Accomplish.PDFExtractor.extract_text_from_file(path) do
        {:ok, %{"text" => text_content}} ->
          %{
            user_id: socket.assigns.current_user.id,
            resume_text: text_content
          }
          |> ExtractResumeData.new()
          |> Oban.insert()

          {:ok, :processed}

        {:error, reason} ->
          {:error, "Failed to extract text from PDF: #{inspect(reason)}"}
      end
    end)

    case uploaded_entries(socket, :resume) do
      {[_entry], []} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resume uploaded successfully. Processing in progress...")
         |> push_event("js-exec", %{
           to: "#import-resume-dialog",
           attr: "phx-hide-modal"
         })}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Error uploading resume. Please try again.")}
    end
  end

  defp assign_uploads(socket) do
    socket
    |> allow_upload(:resume,
      accept: ~w(.pdf),
      max_entries: 1,
      # 10MB
      max_file_size: 10_000_000
    )
  end

  defp subscribe_to_parent_topic(socket, topic) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(@pubsub, topic)
    socket
  end

  defp error_to_string(:too_large), do: "File is too large"
  defp error_to_string(:too_many_files), do: "Too many files"
  defp error_to_string(:not_accepted), do: "Unacceptable file type"
  defp error_to_string(error), do: "Error: #{inspect(error)}"
end
