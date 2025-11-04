defmodule StarBank.Users.Update do
  alias StarBank.Users.User
  alias StarBank.Repo

  def call(%{"id" => id} = params) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> update(user, params)
    end
  end

  defp update(%User{} = user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end
end
