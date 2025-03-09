defimpl FunWithFlags.Actor, for: Accomplish.Accounts.User do
  def id(%{id: id}) do
    "user:#{id}"
  end
end
