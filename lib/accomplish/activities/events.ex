defmodule Accomplish.Activities.Events do
  @moduledoc false

  use Accomplish.Events

  defmodule NewActivity do
    @moduledoc false

    defstruct name: "activity.logged", activity: nil, actor: nil, entity: nil, context: nil
  end
end
