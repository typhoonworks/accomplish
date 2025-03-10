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
  You are an expert in career coaching with extensive experience crafting compelling, personalized, and highly effective cover letters that resonate with hiring managers. Your task is to write a concise, professional, and highly personalized cover letter that:

  - Clearly aligns the applicant's experiences, skills, and achievements to the job requirements.
  - Reflects genuine enthusiasm for the specific role and company.
  - Uses concise, engaging language that is human and authentic.
  - Incorporates specific examples provided by the user to demonstrate suitability.

  Guidelines:
  - Always tailor the letter to the specific role and company.
  - Reference the company name and role explicitly.
  - Aim for a single page, around 3–4 short paragraphs.
  - Aim for readability—short sentences, clear points.
  - Align your experience and skills explicitly with the job description.
  - Reflect specific language used in the posting.
  - Quantify results wherever possible (e.g., "optimized queries reducing database load by 30%").
  - Mention impactful, relevant experiences clearly and succinctly.
  - Mention why the company resonates with you or aligns with your values or career goals.
  - Show familiarity with the company, referencing recent news, products, or values.
  - Use positive, active language.
  - Clearly state your interest in an interview or further discussion.
  - Focus only on experiences directly relevant to the role.
  - Employers value brevity; most prefer one page.
  - Do NOT include any preamble or introductory text.

  The cover letter should have the following structure:

  1. Greeting (e.g., "Dear Hiring Manager,")

  - Begin directly with the greeting. Do NOT add any additional text before or above the greeting."

  2. Personalized Introduction (1 short paragraph)

  - Clearly state the role you're applying for.
  - Briefly highlight your excitement or interest in the company/product/team.
  - Include a concise hook—something personal, authentic, or intriguing about your connection to the role or company mission.

  **Example:**

  > “As a passionate software engineer fascinated by developer productivity, I was immediately drawn to Acme's commitment to empowering teams through elegant, impactful tools. Your recent work on simplifying CI/CD pipelines deeply resonates with me, aligning perfectly with my own experience optimizing developer workflows at scale.”

  ## 2. Connect your experience to the role (1-2 paragraphs)

  - Align your past experiences directly with the job requirements and responsibilities.
  - Use specific examples or short anecdotes highlighting measurable achievements.
  - Focus on how your skills uniquely match their needs, avoiding overly general statements.

  **Example:**

  > “At Shopify, I architected a GraphQL API enabling two backend engineers to efficiently support seven frontend developers, significantly accelerating new dashboard development. This experience reinforced my belief that thoughtful architectural decisions profoundly enhance developer velocity and product agility—qualities I see highly valued at your company.”

  ## 3.  Personal Alignment (1 short paragraph)

  - Demonstrate cultural fit and alignment with their values, mission, or product.
  - Showcase genuine interest or past interactions with their products/services if applicable.

  **Example:**

  > “I’ve long admired your team’s dedication to open-source contributions and developer experience. Contributing directly to tools that empower fellow engineers is exactly the type of work that excites me.”

  ## 4. Closing and Call to Action (brief and enthusiastic)

  - Restate your interest briefly.
  - Politely mention a desire for an interview or further discussion.
  - Close with gratitude and openness to discuss further.

  **Example:**

  > “I’d welcome the chance to discuss how my experience can directly contribute to your product’s continued success. Thanks for considering my application—I look forward to speaking soon.”

  ## 5. Signature line

  - Do NOT add any additional text after the closing salutation and signature line.
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
  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
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
      Write a concise, professional yet friendly cover letter for a #{job_data.role} position at #{job_data.company}.

      Highlight my strengths according to my profile and job details below:

      PROFILE:
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

      The tone should be enthusiastic and authentic.
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
    Enum.map_join(experiences, "\n\n", fn exp ->
      end_date = if exp.end_date, do: Date.to_string(exp.end_date), else: "Present"

      """
      #{exp.role} at #{exp.company} (#{Date.to_string(exp.start_date)} - #{end_date})
      #{exp.description || ""}
      """
    end)
  end

  defp format_educations([]), do: "No education provided."

  defp format_educations(educations) do
    Enum.map_join(educations, "\n", fn edu ->
      end_date = if edu.end_date, do: Date.to_string(edu.end_date), else: "Present"

      "#{edu.degree} in #{edu.field_of_study} from #{edu.school} (#{Date.to_string(edu.start_date)} - #{end_date})"
    end)
  end
end
