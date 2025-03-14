defmodule Accomplish.JobApplications.Events do
  @moduledoc false

  defmodule NewJobApplication do
    @moduledoc false

    defstruct name: "job_application.created", application: nil
  end

  defmodule JobApplicationStatusUpdated do
    @moduledoc false

    defstruct name: "job_application.status_updated", application: nil, from: nil, to: nil
  end

  defmodule JobApplicationUpdated do
    @moduledoc false

    defstruct name: "job_application.updated", application: nil, diff: %{}
  end

  defmodule JobApplicationImported do
    @moduledoc false

    defstruct name: "job_application.imported", application: nil
  end

  defmodule JobApplicationDeleted do
    @moduledoc false

    defstruct name: "job_application.deleted", application: nil
  end

  defmodule JobApplicationNewStage do
    @moduledoc false
    defstruct name: "job_application.stage_added", application: nil, stage: nil
  end

  defmodule JobApplicationCurrentStageUpdated do
    @moduledoc false
    defstruct name: "job_application.changed_current_stage", application: nil, from: nil, to: nil
  end

  defmodule JobApplicationStageStatusUpdated do
    @moduledoc false

    defstruct name: "job_application.stage_status_updated",
              stage: nil,
              application: nil,
              from: nil,
              to: nil
  end

  defmodule JobApplicationStageUpdated do
    @moduledoc false

    defstruct name: "job_application.stage_updated",
              stage: nil,
              application: nil,
              diff: %{}
  end

  defmodule JobApplicationStageDeleted do
    @moduledoc false

    defstruct name: "job_application.stage_deleted", application: nil, stage: nil
  end

  defmodule JobApplicationStageRestored do
    @moduledoc false

    defstruct name: "job_application.stage_restored", application: nil, stage: nil
  end
end
