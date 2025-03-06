alias Accomplish.Repo
alias Accomplish.Accounts
alias Accomplish.JobApplications
alias Accomplish.Activities

IO.puts("Cleaning up the database...")

tables = [
  "activities",
  "job_application_stages",
  "job_applications",
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
  # 90 days
  token_ttl: 90 * 24 * 60 * 60
}

{:ok, app} = Accomplish.OAuth.create_application(attrs)

IO.puts("Creating initial user...")

{:ok, user} =
  Accounts.register_user(
    %{
      email: "rod@me.local",
      password: "password@123",
      username: "rod"
    },
    min_length: 3
  )

IO.puts("Seeding Job Applications...")

# ================================
# Stripe Application
# ================================

stripe_attrs = %{
  company: %{name: "Stripe", website: "https://stripe.com"},
  role: "Backend Engineer",
  status: :interviewing,
  applied_at: DateTime.new!(~D[2024-12-20], ~T[00:00:00], "Etc/UTC"),
  notes: "Excited about their engineering culture and distributed systems work."
}

{:ok, stripe_app} = JobApplications.create_application(user, stripe_attrs)

stripe_stages = [
  %{
    title: "Resume Screening",
    type: :screening,
    date: DateTime.new!(~D[2024-12-22], ~T[00:00:00], "Etc/UTC"),
    notes: "Resume passed initial screening"
  },
  %{
    title: "Recruiter Call",
    type: :screening,
    date: DateTime.new!(~D[2024-12-27], ~T[00:00:00], "Etc/UTC"),
    notes: "30-minute call with recruiter Sarah."
  }
]

for stage_attrs <- stripe_stages do
  {:ok, stage, _} = JobApplications.add_stage(stripe_app, stage_attrs)

  Activities.log_activity(
    user,
    "job_application.stage_added",
    stage,
    %{},
    DateTime.utc_now(),
    stripe_app
  )
end

# ================================
# GitLab Application (Rejected)
# ================================

gitlab_attrs = %{
  company: %{name: "GitLab", website: "https://gitlab.com"},
  role: "Frontend Engineer",
  status: :rejected,
  applied_at: DateTime.new!(~D[2024-11-10], ~T[00:00:00], "Etc/UTC"),
  notes: "Looking for more Vue.js experience."
}

{:ok, gitlab_app} = JobApplications.create_application(user, gitlab_attrs)

gitlab_stages = [
  %{
    title: "Initial Screening",
    type: :screening,
    date: DateTime.new!(~D[2024-11-15], ~T[00:00:00], "Etc/UTC"),
    notes: "Quick screening call with HR"
  },
  %{
    title: "Technical Interview",
    type: :interview,
    date: DateTime.new!(~D[2024-11-25], ~T[00:00:00], "Etc/UTC"),
    notes: "Interview focused on Vue.js and frontend architecture"
  }
]

for stage_attrs <- gitlab_stages do
  {:ok, stage, _} = JobApplications.add_stage(gitlab_app, stage_attrs)

  Activities.log_activity(
    user,
    "job_application.stage_added",
    stage,
    %{},
    DateTime.utc_now(),
    gitlab_app
  )
end

# ================================
# Shopify Application (Offer)
# ================================

shopify_attrs = %{
  company: %{name: "Shopify", website: "https://shopify.com"},
  role: "Full Stack Developer",
  status: :offer,
  applied_at: DateTime.new!(~D[2024-12-05], ~T[00:00:00], "Etc/UTC"),
  notes: "Excited about the offer! $140K base salary, stock options."
}

{:ok, shopify_app} = JobApplications.create_application(user, shopify_attrs)

shopify_stages = [
  %{
    title: "Recruiter Screen",
    type: :screening,
    date: DateTime.new!(~D[2024-12-08], ~T[00:00:00], "Etc/UTC"),
    notes: "Call with Greg from talent acquisition"
  },
  %{
    title: "Technical Challenge",
    type: :assessment,
    date: DateTime.new!(~D[2024-12-15], ~T[00:00:00], "Etc/UTC"),
    notes: "Building a small e-commerce application"
  },
  %{
    title: "Final Interview",
    type: :interview,
    date: DateTime.new!(~D[2025-01-12], ~T[00:00:00], "Etc/UTC"),
    notes: "Meeting with CTO"
  }
]

for stage_attrs <- shopify_stages do
  {:ok, stage, _} = JobApplications.add_stage(shopify_app, stage_attrs)

  Activities.log_activity(
    user,
    "job_application.stage_added",
    stage,
    %{},
    DateTime.utc_now(),
    shopify_app
  )
end

IO.puts("Seeding completed successfully!")
