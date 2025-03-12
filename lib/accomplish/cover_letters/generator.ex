defmodule Accomplish.CoverLetters.Generator do
  @moduledoc """
  Service for generating cover letters for job applications using LLMs.

  This module uses profile and job application data to generate custom cover letters.
  """

  require Logger

  alias Accomplish.Profiles
  alias Accomplish.CoverLetters
  alias Accomplish.Streaming
  alias Accomplish.AI.Prompt

  @model "claude-3-5-haiku-20241022"
  @max_tokens 800
  @temperature 0.3

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

  > "As a passionate software engineer fascinated by developer productivity, I was immediately drawn to Acme's commitment to empowering teams through elegant, impactful tools. Your recent work on simplifying CI/CD pipelines deeply resonates with me, aligning perfectly with my own experience optimizing developer workflows at scale."

  ## 2. Connect your experience to the role (1-2 paragraphs)

  - Align your past experiences directly with the job requirements and responsibilities.
  - Use specific examples or short anecdotes highlighting measurable achievements.
  - Focus on how your skills uniquely match their needs, avoiding overly general statements.

  **Example:**

  > "At Shopify, I architected a GraphQL API enabling two backend engineers to efficiently support seven frontend developers, significantly accelerating new dashboard development. This experience reinforced my belief that thoughtful architectural decisions profoundly enhance developer velocity and product agility—qualities I see highly valued at your company."

  ## 3.  Personal Alignment (1 short paragraph)

  - Demonstrate cultural fit and alignment with their values, mission, or product.
  - Showcase genuine interest or past interactions with their products/services if applicable.

  **Example:**

  > "I've long admired your team's dedication to open-source contributions and developer experience. Contributing directly to tools that empower fellow engineers is exactly the type of work that excites me."

  ## 4. Closing and Call to Action (brief and enthusiastic)

  - Restate your interest briefly.
  - Politely mention a desire for an interview or further discussion.
  - Close with gratitude and openness to discuss further.

  **Example:**

  > "I'd welcome the chance to discuss how my experience can directly contribute to your product's continued success. Thanks for considering my application—I look forward to speaking soon."

  ## 5. Signature line

  - Do NOT add any additional text after the closing salutation and signature line.
  """

  @doc """
  Starts the generation of a cover letter with streaming output.

  Returns a stream ID that can be used to track the stream.

  ## Parameters
    - user: The current user
    - application: The job application to generate a cover letter for
    - cover_letter_id: The ID of the cover letter to update
    - provider: The provider name to select the adapter, defaults to :anthropic

  ## Returns
    - {:ok, stream_id} on successful stream initialization
    - {:error, reason} on failure
  """
  def start_stream(user, application, cover_letter_id, provider \\ :anthropic) do
    stream_id = "cover_letter_stream_#{cover_letter_id}"

    save_fn = fn buffer ->
      cover_letter = CoverLetters.get_cover_letter!(cover_letter_id)
      CoverLetters.update_streaming_content(cover_letter, buffer)
    end

    messages = build_messages(user, application)

    prompt =
      Prompt.new(
        messages,
        @model,
        @system_message,
        @max_tokens,
        @temperature
      )

    stream_opts = [save_interval: 5_000, ttl: 6_000]
    Streaming.start_streaming(stream_id, save_fn, provider, prompt, stream_opts)
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp build_messages(user, application) do
    profile = Profiles.get_profile_by_user(user.id)
    experiences = (profile && Profiles.list_experiences(profile)) || []
    educations = (profile && Profiles.list_educations(profile)) || []

    relevant_experiences =
      experiences
      |> Enum.sort_by(fn exp -> exp.start_date end, {:desc, Date})
      |> Enum.take(3)

    relevant_educations =
      educations
      |> Enum.sort_by(fn edu -> edu.start_date end, {:desc, Date})
      |> Enum.take(2)

    profile_data = %{
      name: Accomplish.Accounts.User.display_name(user),
      headline: profile && profile.headline,
      bio: profile && profile.bio,
      skills: profile && profile.skills,
      experiences: relevant_experiences,
      educations: relevant_educations
    }

    job_data = %{
      role: application.role,
      company: application.company.name,
      company_website: application.company.website_url,
      description: application.job_description,
      workplace_type: application.workplace_type,
      employment_type: application.employment_type
    }

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

    [%{role: "user", content: String.trim(prompt_message)}]
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
