IEx.configure(history_size: 500)

import Ecto.Query
alias Accomplish.Repo
alias Accomplish.Accounts
alias Accomplish.CoverLetters
alias Accomplish.JobApplications
alias Accomplish.Activities
alias Accomplish.Profiles

user = Accounts.get_user_by_email("jack@me.local")

IO.puts("Loaded .iex.exs with custom settings!")
