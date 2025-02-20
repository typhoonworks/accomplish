defmodule Accomplish.JobApplications.Events do
  @moduledoc false

  defmodule NewJobApplication do
    @moduledoc false

    defstruct name: nil, application: nil, company: nil
  end

  defmodule JobApplicationDeleted do
    @moduledoc false

    defstruct name: nil, application: nil
  end
end
