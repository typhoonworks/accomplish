defmodule Accomplish.Profiles.Events do
  @moduledoc false

  defmodule ProfileImported do
    @moduledoc false

    defstruct name: "profile.imported", user: nil, profile: nil, experiences: [], educations: []
  end
end
