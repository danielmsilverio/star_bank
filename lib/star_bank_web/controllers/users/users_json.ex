defmodule StarBankWeb.Users.UsersJSON do
  alias StarBank.Users.User

  def create(%{user: user}) do
    %{
      message: "Usuário criado com sucesso",
      data: data(user)
    }
  end

  def get(%{user: user}), do: %{data: data(user)}

  def update(%{user: user}) do
    %{
      message: "Usuário atualizado com sucesso",
      data: data(user)
    }
  end

  def delete(%{user: user}) do
    %{
      message: "Usuário deletado com sucesso",
      data: data(user)
    }
  end

  def login(%{token: token}) do
    %{
      message: "Usuário authenticado com sucesso",
      bearer: token
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      cep: user.cep
    }
  end
end
