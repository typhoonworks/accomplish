defmodule AccomplishWeb.Components.SkillSelector do
  @moduledoc """
  A live component for selecting skills with auto-suggestions and displaying them as pills.

  Skills are stored in a central skills database and suggested based on partial matches
  and popularity across the platform.
  """
  use AccomplishWeb, :live_component

  import AccomplishWeb.CoreComponents
  import AccomplishWeb.ShadowrunComponents

  alias Accomplish.Profiles.Skills

  def render(assigns) do
    ~H"""
    <div id={@id} class="space-y-2" phx-hook="SkillSelector">
      <h3 class="text-zinc-400">Skills</h3>
      <.shadow_button
        :if={!@show_input}
        phx-click="toggle-skill-input"
        phx-target={@myself}
        variant="transparent"
        class="text-zinc-300 text-xs"
      >
        <.icon name="hero-plus" class="size-3" /> Add skills
      </.shadow_button>

      <div
        id="skill-input-container"
        class={"transition-all duration-300 ease-in-out " <> if(@show_input, do: "", else: "hidden")}
      >
        <div class="relative">
          <input
            id="skill-input"
            type="text"
            phx-keydown="skill-input-keydown"
            phx-target={@myself}
            value={@input_value}
            placeholder="Type a skill (e.g., JavaScript, React, Python)"
            class="w-full p-2 bg-zinc-800 text-zinc-200 text-sm rounded-md border border-zinc-700 focus:outline-none focus:ring-1 focus:ring-purple-600 focus:border-purple-600"
          />
          <div
            :if={@suggestions != [] and @input_value != ""}
            class="absolute z-10 w-full mt-1 bg-zinc-800 border border-zinc-700 rounded-md shadow-lg max-h-60 overflow-y-auto"
            id={"#{@id}-suggestions"}
          >
            <%= for suggestion <- @suggestions do %>
              <div
                phx-click="select-suggestion"
                phx-target={@myself}
                phx-value-skill={suggestion.name}
                class="p-2 hover:bg-zinc-700 cursor-pointer text-sm text-zinc-200 flex items-center justify-between"
              >
                <span>{suggestion.name}</span>
              </div>
            <% end %>
          </div>
          <div class="flex justify-end mt-2">
            <.shadow_button
              type="button"
              variant="secondary"
              phx-click="cancel-skill-input"
              phx-target={@myself}
              class="mr-2 text-xs"
            >
              Cancel
            </.shadow_button>
            <.shadow_button
              type="button"
              variant="primary"
              phx-click="add-skill"
              phx-target={@myself}
              disabled={@input_value == ""}
              class="text-xs"
            >
              Add
            </.shadow_button>
          </div>
        </div>
      </div>

      <div class="flex flex-wrap gap-2 mt-2">
        <%= for skill <- @skills do %>
          <.shadow_pill class="group">
            {skill}
            <button
              type="button"
              phx-click="remove-skill"
              phx-target={@myself}
              phx-value-skill={skill}
              class="ml-2 text-zinc-400 hover:text-zinc-200 focus:outline-none"
            >
              <.icon name="hero-x-mark" class="size-3" />
            </button>
          </.shadow_pill>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok,
     assign(socket,
       skills: [],
       show_input: false,
       input_value: "",
       suggestions: []
     )}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:skills, fn -> assigns[:profile].skills || [] end)

    {:ok, socket}
  end

  def handle_event("toggle-skill-input", _, socket) do
    suggestions = Skills.suggest_skills(nil, 5)

    {:noreply, assign(socket, show_input: true, input_value: "", suggestions: suggestions)}
  end

  def handle_event("cancel-skill-input", _, socket) do
    {:noreply, assign(socket, show_input: false, input_value: "", suggestions: [])}
  end

  def handle_event("skill-input-keydown", %{"key" => "Enter", "value" => value}, socket)
      when value != "" do
    {:noreply, add_skill(socket, value)}
  end

  def handle_event("skill-input-keydown", %{"key" => "Escape"}, socket) do
    {:noreply, assign(socket, show_input: false, input_value: "", suggestions: [])}
  end

  def handle_event("skill-input-keydown", %{"value" => value}, socket) do
    socket =
      if value == "" do
        suggestions = Skills.suggest_skills(nil, 5)
        assign(socket, input_value: "", suggestions: suggestions)
      else
        suggestions = Skills.suggest_skills(value, 8)
        assign(socket, input_value: value, suggestions: suggestions)
      end

    {:noreply, socket}
  end

  def handle_event("skill-input-blur", %{"value" => _value}, socket) do
    {:noreply, socket}
  end

  def handle_event("select-suggestion", %{"skill" => skill}, socket) do
    {:noreply, add_skill(socket, skill)}
  end

  def handle_event("add-skill", _, %{assigns: %{input_value: value}} = socket) when value != "" do
    {:noreply, add_skill(socket, value)}
  end

  def handle_event("add-skill", _, socket) do
    {:noreply, socket}
  end

  def handle_event("remove-skill", %{"skill" => skill}, socket) do
    updated_skills = List.delete(socket.assigns.skills, skill)

    send(self(), {:update_profile_skills, updated_skills})

    {:noreply, assign(socket, skills: updated_skills)}
  end

  defp add_skill(socket, skill) do
    skill = String.trim(skill)
    current_skills = socket.assigns.skills || []

    if skill != "" and skill not in current_skills do
      Skills.increment_skill_usage(skill)

      updated_skills = current_skills ++ [skill]

      send(self(), {:update_profile_skills, updated_skills})

      assign(socket,
        skills: updated_skills,
        input_value: "",
        suggestions: []
      )
    else
      assign(socket, input_value: "", suggestions: [])
    end
  end
end
