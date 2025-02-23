defmodule AccomplishWeb.JobApplicationLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications

  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header>
          <:title>
            <div class="flex lg:items-center lg:gap-1">
              <.link href={~p"/job_applications/"} class="hidden lg:inline">Job Applications</.link>
              <span class="hidden lg:inline-flex items-center text-zinc-400">
                <.icon name="hero-chevron-right" class="size-3" />
              </span>
              <span class="inline">{@application.role} at {@application.company.name}</span>
            </div>
          </:title>
          <:actions>
            <.nav_button
              icon="hero-document-text"
              text="Overview"
              href={~p"/job_applications/#{@application.slug}/overview"}
              active={@live_action == :overview}
            />
            <.nav_button
              icon="hero-square-3-stack-3d"
              text="Stages"
              href={~p"/job_applications/#{@application.slug}/stages"}
              active={@live_action == :stages}
            />
          </:actions>
        </.page_header>
      </:page_header>

      <div class="mt-8 w-full">
        <div class="-mx-4 -my-2 sm:-mx-6 lg:-mx-8">
          <%= case @live_action do %>
            <% :overview -> %>
              {render_overview(assigns)}
            <% :stages -> %>
              {render_stages(assigns)}
          <% end %>
        </div>
      </div>
    </.layout>
    """
  end

  defp render_overview(assigns) do
    ~H"""
    <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24 ">
      <div class="space-y-4">
        <.shadow_input
          field={@form[:role]}
          placeholder="Job role"
          class="text-3xl tracking-tighter"
          phx-blur="save_field"
          phx-value-field="role"
        />

        <p class="text-zinc-300">{@application.company.name}</p>
      </div>

      <div class="mt-12 space-y-2">
        <h3 class="text-zinc-400">Notes</h3>
        <.shadow_input
          field={@form[:notes]}
          type="textarea"
          placeholder="Write down key details, next moves, or important notes..."
          class="text-base tracking-tighter w-full"
          socket={@socket}
          phx-blur="save_field"
          phx-value-field="notes"
        />
      </div>
    </section>
    """
  end

  defp render_stages(assigns) do
    ~H"""
    <div>
      <h3 class="text-lg font-semibold">Stages</h3>
      <ul>
        <%= for stage <- @application.stages do %>
          <li class="border-b py-2">{stage.title}</li>
        <% end %>
      </ul>
    </div>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    applicant = socket.assigns.current_user

    case JobApplications.get_application_by_slug(applicant, slug, [
           :company,
           :current_stage,
           :stages
         ]) do
      {:ok, application} ->
        form = JobApplications.change_application_form(Map.from_struct(application))

        socket =
          socket
          |> assign(application: application)
          |> assign(form: to_form(form))

        {:ok, socket}

      :error ->
        {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  def handle_event("save_field", %{"field" => field, "value" => value}, socket) do
    application = socket.assigns.application

    case JobApplications.update_application(application, %{
           String.to_existing_atom(field) => value
         }) do
      {:ok, _updated_application} ->
        updated_application =
          JobApplications.get_application!(application.id, [
            :company,
            :current_stage,
            :stages
          ])

        {:noreply, assign(socket, application: updated_application)}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
