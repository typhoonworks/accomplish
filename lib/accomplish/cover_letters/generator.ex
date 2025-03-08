defmodule Accomplish.CoverLetters.Generator do
  @moduledoc """
  Service for generating cover letters for job applications using LLMs.

  This module uses profile and job application data to generate custom cover letters.
  """

  require Logger
  import Accomplish.ConfigHelpers

  alias Accomplish.Profiles

  @model "claude-3-5-haiku-20241022"

  @system_message """
  You are an expert career coach specializing in writing outstanding cover letters. Your task is to create
  a highly personalized cover letter based on:

  1. The user's professional profile (experience, education, skills)
  2. The specific job details (role, company, job description)

  Guidelines:
  - Keep the tone professional but personable
  - Highlight relevant skills and experience that match the job requirements
  - Demonstrate knowledge of the company
  - Be specific about why the candidate is a good fit for this particular role
  - Keep paragraphs concise and impactful
  - Format as a proper business letter with date, greeting, body, closing, and name
  - Total length should be 300-400 words
  - Do not include address blocks or contact information

  The cover letter should have the following structure:
  - Date (current date)
  - Greeting (e.g., "Dear Hiring Manager,")
  - Opening paragraph: Express interest in the position and briefly mention how you learned about it
  - 2-3 body paragraphs: Highlight relevant skills/experience and how they align with the job
  - Closing paragraph: Express enthusiasm, request an interview, and thank them
  - Professional closing (e.g., "Sincerely,")
  - Full name
  """

  @doc """
  Generates a cover letter using the Claude API with streaming. Sends chunks to the caller.

  ## Parameters
    - pid: Process ID to receive streamed content
    - user: The current user
    - application: The job application

  ## Returns
    - :ok on successful generation
    - {:error, reason} on failure
  """
  def generate_streaming(pid, user, application) do
    Task.start(fn ->
      # Configure client and prepare request data
      profile = Profiles.get_profile_by_user(user.id)
      experiences = (profile && Profiles.list_experiences(profile)) || []
      educations = (profile && Profiles.list_educations(profile)) || []

      # Get relevant experiences (most recent 2-3)
      relevant_experiences =
        experiences
        |> Enum.sort_by(fn exp -> exp.start_date end, {:desc, Date})
        |> Enum.take(3)

      # Get relevant education
      relevant_educations =
        educations
        |> Enum.sort_by(fn edu -> edu.start_date end, {:desc, Date})
        |> Enum.take(2)

      profile_data = %{
        name: Accomplish.Accounts.User.display_name(user),
        headline: profile && profile.headline,
        bio: profile && profile.bio,
        skills: profile && profile.skills,
        experiences:
          Enum.map(relevant_experiences, fn exp ->
            %{
              company: exp.company,
              role: exp.role,
              start_date: exp.start_date,
              end_date: exp.end_date,
              description: exp.description
            }
          end),
        educations:
          Enum.map(relevant_educations, fn edu ->
            %{
              school: edu.school,
              degree: edu.degree,
              field_of_study: edu.field_of_study,
              start_date: edu.start_date,
              end_date: edu.end_date
            }
          end)
      }

      job_data = %{
        role: application.role,
        company: application.company.name,
        company_website: application.company.website_url,
        description: application.job_description,
        workplace_type: application.workplace_type,
        employment_type: application.employment_type
      }

      api_key = get_env("ANTHROPIC_API_KEY")

      prompt_message = """
      Please create a personalized cover letter based on the candidate's profile and the job details below:

      CANDIDATE PROFILE:
      Name: #{profile_data.name}
      Headline: #{profile_data.headline || "N/A"}
      Bio: #{profile_data.bio || "N/A"}
      Skills: #{Enum.join(profile_data.skills || [], ", ")}

      Work Experience:
      #{format_experiences(profile_data.experiences)}

      Education:
      #{format_educations(profile_data.educations)}

      JOB DETAILS:
      Role: #{job_data.role}
      Company: #{job_data.company}
      Company Website: #{job_data.company_website || "N/A"}
      Workplace Type: #{job_data.workplace_type || "N/A"}
      Employment Type: #{job_data.employment_type || "N/A"}

      Job Description:
      #{job_data.description || "No job description provided."}

      Please write a cover letter for this specific job opportunity that highlights the candidate's relevant skills and experience.
      """

      messages = [
        %{role: "user", content: String.trim(prompt_message)}
      ]

      # Initialize the client
      client = Anthropix.init(api_key)
      Logger.debug("Initializing Anthropix client")

      try do
        # Call the Anthropix API with the provided PID for streaming
        # Note: Anthropix will send messages to the specified PID
        result =
          Anthropix.chat(client,
            model: @model,
            system: @system_message,
            messages: messages,
            stream: pid,
            max_tokens: 4000,
            temperature: 0.7
          )

        Logger.debug("Anthropix.chat result: #{inspect(result)}")

        # The result should be {:ok, task} where task is a Task struct
        # We don't need to do anything with the task as Anthropix
        # will send the streaming messages directly to the PID
      rescue
        e ->
          Logger.error("Exception in cover letter generation: #{inspect(e)}")
          send(pid, {:stream_error, "Exception generating cover letter: #{inspect(e)}"})
      end
    end)

    :ok
  end

  defp format_experiences([]), do: "No work experience provided."

  defp format_experiences(experiences) do
    experiences
    |> Enum.map(fn exp ->
      end_date = if exp.end_date, do: Date.to_string(exp.end_date), else: "Present"

      """
      #{exp.role} at #{exp.company} (#{Date.to_string(exp.start_date)} - #{end_date})
      #{exp.description || ""}
      """
    end)
    |> Enum.join("\n\n")
  end

  defp format_educations([]), do: "No education provided."

  defp format_educations(educations) do
    educations
    |> Enum.map(fn edu ->
      end_date = if edu.end_date, do: Date.to_string(edu.end_date), else: "Present"

      "#{edu.degree} in #{edu.field_of_study} from #{edu.school} (#{Date.to_string(edu.start_date)} - #{end_date})"
    end)
    |> Enum.join("\n")
  end
end
