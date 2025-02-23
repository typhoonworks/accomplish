defmodule Accomplish.JobApplications.Stages do
  @moduledoc false

  use Accomplish.Context

  @stages [
    %{title: "Recruiter Screen", type: :screening, is_final_stage: false},
    %{title: "Technical Interview", type: :interview, is_final_stage: false},
    %{title: "Live Coding", type: :assessment, is_final_stage: false},
    %{title: "Take-Home Assignment", type: :assessment, is_final_stage: false},
    %{title: "System Design", type: :interview, is_final_stage: false},
    %{title: "Final Interview", type: :interview, is_final_stage: true}
  ]

  def predefined_stages, do: @stages
end
