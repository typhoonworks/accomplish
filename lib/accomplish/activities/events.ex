defmodule Accomplish.Activities.Events do
  @moduledoc false

  defmodule NewActivity do
    @moduledoc false

    defstruct name: "activity.logged", activity: nil, actor: nil, target: nil
  end
end
