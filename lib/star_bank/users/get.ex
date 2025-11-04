defmodule StarBank.Users.Get do
  alias StarBank.Users.User
  alias StarBank.Repo

  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
