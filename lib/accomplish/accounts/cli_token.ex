defmodule Accomplish.Accounts.CliToken do
  use Accomplish.Schema

  alias Accomplish.Accounts.User
  alias Accomplish.Accounts.CliToken

  @permitted ~w(token expires_at user_id context state)a
  @required ~w(token expires_at state)a

  @five_minutes_expiration 300
  @rand_size 32
  @hash_algorithm :sha256

  schema "cli_tokens" do
    field :token, :string
    field :expires_at, :utc_datetime
    field :context, :map, default: %{}
    field :state, :string, default: "pending"

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a CLI token with optional user and context.
  """
  def build_token(context \\ %{}) do
    raw_token = :crypto.strong_rand_bytes(@rand_size) |> Base.url_encode64(padding: false)

    hashed_token =
      :crypto.hash(@hash_algorithm, Base.url_decode64!(raw_token, padding: false))
      |> Base.encode16(case: :lower)

    %CliToken{
      token: hashed_token,
      expires_at:
        DateTime.add(
          DateTime.utc_now() |> DateTime.truncate(:second),
          @five_minutes_expiration,
          :second
        ),
      context: context,
      state: "pending"
    }
    |> Map.put(:raw_token, raw_token)
  end

  @doc """
  Updates the state of a CLI token.
  """
  def state_changeset(token, new_state) do
    token
    |> changeset(%{state: new_state})
  end

  @doc """
  Changeset function for validation.
  """
  def changeset(token, attrs) do
    token
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
