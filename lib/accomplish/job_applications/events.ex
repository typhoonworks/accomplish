defmodule Accomplish.JobApplications.Events do
  @moduledoc false

  defmodule NewJobApplication do
    @moduledoc false

    defstruct name: "job_application.created", application: nil, company: nil
  end

  defmodule JobApplicationStatusUpdated do
    @moduledoc false

    defstruct name: "job_application.status_updated", application: nil, from: nil, to: nil
  end

  defmodule JobApplicationUpdated do
    @moduledoc false

    defstruct name: "job_application.updated", application: nil, company: nil, diff: %{}
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
    defstruct name: "job_application.stage_updated", application: nil, from: nil, to: nil
  end
end
