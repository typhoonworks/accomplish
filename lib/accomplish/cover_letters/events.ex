defmodule Accomplish.CoverLetters.Events do
  @moduledoc false

  defmodule NewCoverLetter do
    @moduledoc false

    defstruct name: "cover_letter.created", cover_letter: nil, application: nil
  end

  defmodule CoverLetterUpdated do
    @moduledoc false

    defstruct name: "cover_letter.updated", cover_letter: nil, application: nil, diff: %{}
  end

  defmodule CoverLetterDeleted do
    @moduledoc false

    defstruct name: "cover_letter.deleted", cover_letter: nil, application: nil
  end

  defmodule CoverLetterSubmitted do
    @moduledoc false

    defstruct name: "cover_letter.submitted", cover_letter: nil, application: nil
  end
end
