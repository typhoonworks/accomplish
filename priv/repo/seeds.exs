# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Accomplish.Repo.insert!(%Accomplish.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Accomplish.Repo
alias Accomplish.Accounts
alias Accomplish.JobApplications
alias Accomplish.Activities

IO.puts("Cleaning up the database...")

tables = [
  "activities",
  "job_application_stages",
  "job_applications",
  "companies",
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

# Create application with rich history - Stripe application
stripe_attrs = %{
  company_name: "Stripe",
  role: "Backend Engineer",
  status: :interviewing,
  applied_at: DateTime.new!(~D[2024-12-20], ~T[00:00:00], "Etc/UTC"),
  notes:
    "Excited about their engineering culture and distributed systems work. Need to brush up on system design concepts before the interview."
}

{:ok, stripe_app} = JobApplications.create_application(user, stripe_attrs)

# Add stages for Stripe application
stripe_stages = [
  %{
    title: "Resume Screening",
    type: :screening,
    position: 1,
    date: DateTime.new!(~D[2024-12-22], ~T[00:00:00], "Etc/UTC"),
    notes: "Resume passed initial screening"
  },
  %{
    title: "Recruiter Call",
    type: :screening,
    position: 2,
    date: DateTime.new!(~D[2024-12-27], ~T[00:00:00], "Etc/UTC"),
    notes: "30-minute call with recruiter Sarah. Discussed experience and expectations."
  },
  %{
    title: "Technical Phone Screen",
    type: :interview,
    position: 3,
    date: DateTime.new!(~D[2025-01-05], ~T[00:00:00], "Etc/UTC"),
    notes: "Coding interview covering data structures and algorithms."
  },
  %{
    title: "Take-Home Assignment",
    type: :assessment,
    position: 4,
    date: DateTime.new!(~D[2025-01-12], ~T[00:00:00], "Etc/UTC"),
    notes: "Build a simple payment processing API with error handling and tests."
  }
]

# Add stages to the Stripe application
for stage_attrs <- stripe_stages do
  {:ok, stage, _} = JobApplications.add_stage(stripe_app, stage_attrs)

  # Log activity for each stage
  Activities.log_activity(
    user,
    "job_application.stage_added",
    stripe_app,
    %{stage_title: stage.title, stage_type: stage.type}
  )
end

# Set current stage to the Take-Home Assignment
# Get the application with stages
stripe_app_with_stages = JobApplications.get_application!(user, stripe_app.id, [:stages])
take_home_stage = Enum.find(stripe_app_with_stages.stages, &(&1.title == "Take-Home Assignment"))
{:ok, _} = JobApplications.set_current_stage(stripe_app_with_stages, take_home_stage.id)

# Log status change to interviewing
Activities.log_activity(
  user,
  "job_application.status_updated",
  stripe_app,
  %{from: :applied, to: :interviewing}
)

# Create Basecamp application - recently applied
basecamp_attrs = %{
  company_name: "Basecamp",
  role: "Software Engineer",
  status: :applied,
  applied_at: DateTime.new!(~D[2025-01-10], ~T[00:00:00], "Etc/UTC"),
  notes: "Love their products and philosophy on work. Applied through their careers page."
}

{:ok, basecamp_app} = JobApplications.create_application(user, basecamp_attrs)

# Create GitLab application - rejected
gitlab_attrs = %{
  company_name: "GitLab",
  role: "Frontend Engineer",
  status: :rejected,
  applied_at: DateTime.new!(~D[2024-11-10], ~T[00:00:00], "Etc/UTC"),
  notes: "Applied for remote position. Looking for more Vue.js experience."
}

{:ok, gitlab_app} = JobApplications.create_application(user, gitlab_attrs)

# Add stages for GitLab application
gitlab_stages = [
  %{
    title: "Initial Screening",
    type: :screening,
    position: 1,
    date: DateTime.new!(~D[2024-11-15], ~T[00:00:00], "Etc/UTC"),
    notes: "Quick screening call with HR"
  },
  %{
    title: "Technical Interview",
    type: :interview,
    position: 2,
    date: DateTime.new!(~D[2024-11-25], ~T[00:00:00], "Etc/UTC"),
    notes: "Interview focused on Vue.js and frontend architecture"
  }
]

# Add stages to the GitLab application
for stage_attrs <- gitlab_stages do
  {:ok, stage, _} = JobApplications.add_stage(gitlab_app, stage_attrs)

  # Log activity for each stage
  Activities.log_activity(
    user,
    "job_application.stage_added",
    gitlab_app,
    %{stage_title: stage.title, stage_type: stage.type}
  )
end

# Get the application with stages
gitlab_app_with_stages = JobApplications.get_application!(user, gitlab_app.id, [:stages])
technical_stage = Enum.find(gitlab_app_with_stages.stages, &(&1.title == "Technical Interview"))
{:ok, _} = JobApplications.set_current_stage(gitlab_app_with_stages, technical_stage.id)

# Log status change to interviewing (past state)
Activities.log_activity(
  user,
  "job_application.status_updated",
  gitlab_app,
  %{from: :applied, to: :interviewing}
)

# Log status change to rejected
Activities.log_activity(
  user,
  "job_application.status_updated",
  gitlab_app,
  %{from: :interviewing, to: :rejected}
)

# Logging rejection feedback
# Activities.log_activity(
#   user,
#   "job_application.feedback_received",
#   gitlab_app,
#   %{
#     message:
#       "Thank you for your interest in GitLab. While we were impressed with your background, we've decided to move forward with candidates who have more extensive Vue.js experience."
#   }
# )

# Create new application - recently offer
shopify_attrs = %{
  company_name: "Shopify",
  role: "Full Stack Developer",
  status: :offer,
  applied_at: DateTime.new!(~D[2024-12-05], ~T[00:00:00], "Etc/UTC"),
  notes: "Excited about the offer! Base salary: $140K, stock options, 5 weeks vacation."
}

{:ok, shopify_app} = JobApplications.create_application(user, shopify_attrs)

# Add stages for Shopify application
shopify_stages = [
  %{
    title: "Recruiter Screen",
    type: :screening,
    position: 1,
    date: DateTime.new!(~D[2024-12-08], ~T[00:00:00], "Etc/UTC"),
    notes: "Call with Greg from talent acquisition"
  },
  %{
    title: "Technical Challenge",
    type: :assessment,
    position: 2,
    date: DateTime.new!(~D[2024-12-15], ~T[00:00:00], "Etc/UTC"),
    notes: "Building a small e-commerce application"
  },
  %{
    title: "Technical Interview",
    type: :interview,
    position: 3,
    date: DateTime.new!(~D[2024-12-22], ~T[00:00:00], "Etc/UTC"),
    notes: "Panel interview with two senior engineers"
  },
  %{
    title: "Culture Fit Interview",
    type: :interview,
    position: 4,
    date: DateTime.new!(~D[2025-01-05], ~T[00:00:00], "Etc/UTC"),
    notes: "Met with team lead and product manager"
  },
  %{
    title: "Final Interview",
    type: :interview,
    position: 5,
    date: DateTime.new!(~D[2025-01-12], ~T[00:00:00], "Etc/UTC"),
    notes: "Meeting with CTO"
  },
  %{
    title: "Offer",
    type: :offer,
    position: 6,
    date: DateTime.new!(~D[2025-01-20], ~T[00:00:00], "Etc/UTC"),
    notes: "$140K base, 15% bonus, stock options, 5 weeks vacation"
  }
]

# Add stages to the Shopify application
for stage_attrs <- shopify_stages do
  {:ok, stage, _} = JobApplications.add_stage(shopify_app, stage_attrs)

  # Log activity for each stage
  Activities.log_activity(
    user,
    "job_application.stage_added",
    shopify_app,
    %{stage_title: stage.title, stage_type: stage.type}
  )
end

# Set current stage to the Offer
shopify_app_with_stages = JobApplications.get_application!(user, shopify_app.id, [:stages])
offer_stage = Enum.find(shopify_app_with_stages.stages, &(&1.title == "Offer"))
{:ok, _} = JobApplications.set_current_stage(shopify_app_with_stages, offer_stage.id)

# Log status changes
Activities.log_activity(
  user,
  "job_application.status_updated",
  shopify_app,
  %{from: :applied, to: :interviewing}
)

Activities.log_activity(
  user,
  "job_application.status_updated",
  shopify_app,
  %{from: :interviewing, to: :offer}
)

if Mix.env() == :dev do
  IO.puts("Generating API key for development environment...")

  dev_api_scopes = ~w(
    repositories:read
    repositories:write
  )

  {:ok, api_key} =
    Accounts.create_api_key(user, %{name: "Development API Key", scopes: dev_api_scopes})

  IO.puts("""
  =====================================
  OAuth Application for Development:
  Client ID: #{app.uid}
  Secret: #{app.secret}
  =====================================

    You can use the following curl command to trigger device auth flows

    ```
    curl -X POST http://localhost:4000/auth/device/code \\
    -H "Content-Type: application/json" \\
    -d '{
      "client_id": "#{app.uid}",
      "scope": "user:read,user:write"
    }'
    ```
  """)

  IO.puts("""
  =====================================
  API Key for Development:
  #{api_key.raw_key}
  =====================================
  """)
end

IO.puts("Seeding completed successfully!")
