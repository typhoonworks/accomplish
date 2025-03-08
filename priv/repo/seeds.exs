alias Accomplish.Repo
alias Accomplish.Accounts
alias Accomplish.JobApplications
alias Accomplish.Activities
alias Accomplish.Profiles

IO.puts("Cleaning up the database...")

tables = [
  "activities",
  "job_application_stages",
  "job_applications",
  "profile_experiences",
  "profile_educations",
  "profiles",
  "api_keys",
  "users",
  "oauth_applications"
]

for table <- tables do
  Repo.query!("TRUNCATE TABLE #{table} CASCADE")
end

IO.puts("Creating OAuth application...")

attrs = %{
  name: "Accomplish CLI",
  redirect_uri: "http://127.0.0.1:8000/callback",
  confidential: true,
  scopes: ["user:read", "user:write"],
  token_ttl: 90 * 24 * 60 * 60
}

{:ok, app} = Accomplish.OAuth.create_application(attrs)

IO.puts("Creating initial user...")

{:ok, user} =
  Accounts.register_user(
    %{
      email: "jack@me.local",
      password: "password@123",
      username: "sparrow"
    },
    min_length: 3
  )

IO.puts("Creating Profile...")

profile_attrs = %{
  user_id: user.id,
  headline: "Senior Software Pirate",
  bio:
    "A wily coder sailin’ the Elixir currents, plunderin’ bugs and brewin’ rum-powered apps with me trusty Phoenix crew.",
  location: "Tortuga, Caribbean Code Isles",
  github_handle: "sparrow",
  linkedin_handle: "sparrow",
  website_url: "https://jacksparrow.io",
  skills: ["Elixir", "Rum", "Phoenix", "Plundering APIs", "Git Storms"]
}

{:ok, profile} = Profiles.upsert_profile(user, profile_attrs)

IO.puts("Adding Education for the user...")

education_attrs = %{
  school: "Port Royal Academy of Piratical Engineering",
  degree: "Bachelor of the Black Arts",
  field_of_study: "Computational Plundering",
  start_date: ~D[2015-09-01],
  end_date: ~D[2019-06-01],
  description:
    "Mastered the arts o’ distributed rum caches, data scurvy-structures, and algorithms fer outwittin’ the Royal Navy’s firewalls."
}

{:ok, _education} = Profiles.add_education(profile, education_attrs)

IO.puts("Adding Experiences for the user...")

experience_attrs_list = [
  %{
    company: "The Black Pearl Coding Co.",
    role: "Junior Code Buccaneer",
    start_date: ~D[2019-07-01],
    end_date: ~D[2021-07-01],
    description:
      "Sailed the Elixir seas, craftin’ APIs and microservices to plunder data from the depths o’ the digital ocean.",
    location: "Tortuga, Caribbean Code Isles",
    workplace_type: "remote"
  },
  %{
    company: "Sparrow’s Tech Armada",
    role: "Captain o’ the Dev Crew",
    start_date: ~D[2021-08-01],
    description:
      "Leadin’ a fierce band o’ coders to forge scalable, rum-fueled event-driven systems, outsmartin’ storms and rival fleets.",
    location: "The Black Pearl, Roamin’ the Cloud Seas",
    workplace_type: "hybrid"
  }
]

for exp_attrs <- experience_attrs_list do
  {:ok, _experience} = Profiles.add_experience(profile, exp_attrs)
end

IO.puts("Seeding Job Applications...")

job_applications = [
  %{
    company: %{name: "Stripe", website_url: "https://stripe.com"},
    role: "Backend Engineer",
    status: :interviewing,
    applied_at: DateTime.new!(~D[2024-12-20], ~T[00:00:00], "Etc/UTC"),
    source: "Company website",
    employment_type: :full_time,
    job_description: """
    Join Stripe's **Backend Engineering** team to build scalable and resilient payment systems.
    We work with **Elixir, Rust, and GraphQL** to power financial infrastructure.

    **Responsibilities:**
    - Develop and optimize backend services for high throughput transactions.
    - Collaborate with cross-functional teams to enhance APIs and developer experience.
    - Implement security best practices for financial transactions.
    """,
    compensation_details: """
    - **Base Salary:** $160,000 - $180,000 per year
    - **Stock Options:** RSUs vested over 4 years
    - **Benefits:** Health, dental, 401k, learning stipend
    """,
    notes:
      "Be this Stripe a treasure chest o’ coin and code? Their Elixir ways and distributed plunderin’ be callin’ to me pirate heart, savvy?"
  },
  %{
    company: %{name: "GitLab", website_url: "https://gitlab.com"},
    role: "Frontend Engineer",
    status: :rejected,
    applied_at: DateTime.new!(~D[2024-11-10], ~T[00:00:00], "Etc/UTC"),
    source: "Referred by a friend",
    employment_type: :contractor,
    job_description: """
    Work with **Vue.js and TypeScript** to build next-gen DevOps tools at GitLab.

    **Key Responsibilities:**
    - Improve UI/UX for GitLab’s **CI/CD pipeline dashboard**.
    - Work closely with product and backend teams to deliver intuitive user experiences.
    - Ensure performance and accessibility best practices.

    """,
    compensation_details: """
    - **Hourly Rate:** $90 - $120/hour
    - **Contract Duration:** 6 months with possible extension
    - **Perks:** Remote work, flexible hours
    """,
    notes:
      "A pox on ’em! They scuttled me chances at Vue.js glory. Methinks their loss be greater than mine own, arr!"
  },
  %{
    company: %{name: "Shopify", website_url: "https://shopify.com"},
    role: "Full Stack Developer",
    status: :offer,
    applied_at: DateTime.new!(~D[2024-12-05], ~T[00:00:00], "Etc/UTC"),
    source: "Found on LinkedIn",
    employment_type: :full_time,
    job_description: """
    Help build and scale **Shopify's e-commerce platform** as a **Full Stack Developer**.

    **You'll be working on:**
    - Developing scalable backend services with **Ruby on Rails**.
    - Implementing frontend features using **React and Tailwind CSS**.
    - Improving developer experience with internal tooling.

    """,
    compensation_details: """
    - **Base Salary:** $140,000
    - **Stock Options:** Equity grant based on experience
    - **Bonuses:** Annual performance bonus of up to 10%
    - **Perks:** Remote-friendly, home office stipend, learning budget
    """,
    notes:
      "Shiver me timbers, an offer from Shopify! A fine bounty o’ gold and code awaits—me compass points true to this prize, arr!"
  }
]

for attrs <- job_applications do
  {:ok, job_app} = JobApplications.create_application(user, attrs)

  stages = [
    %{
      title: "Resume Screening",
      type: :screening,
      date: DateTime.new!(~D[2024-12-22], ~T[00:00:00], "Etc/UTC"),
      notes: "Resume passed initial screening"
    },
    %{
      title: "Technical Interview",
      type: :interview,
      date: DateTime.new!(~D[2025-01-12], ~T[00:00:00], "Etc/UTC"),
      notes: "Interview with engineering team."
    }
  ]

  for stage_attrs <- stages do
    {:ok, stage, _} = JobApplications.add_stage(job_app, stage_attrs)

    Activities.log_activity(
      user,
      "job_application.stage_added",
      stage,
      %{},
      DateTime.utc_now(),
      job_app
    )
  end
end

IO.puts("Seeding completed successfully!")
