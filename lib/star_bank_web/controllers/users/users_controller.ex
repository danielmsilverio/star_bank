defmodule StarBankWeb.Users.UsersController do
  use StarBankWeb, :controller
  alias Bodyguard
  alias StarBankWeb.Token
  alias StarBank.Users
  alias Users.User

  action_fallback StarBankWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(StarBank.Users.Policy, :show, current_user(conn), id),
         {:ok, %User{} = user} <- Users.get(id) do
      conn
      |> put_status(:ok)
      |> render(:get, user: user)
    end
  end

  def update(conn, %{"id" => _id} = params) do
    with :ok <- Bodyguard.permit(StarBank.Users.Policy, :update, current_user(conn), params),
         {:ok, %User{} = user} <- Users.update(params) do
      conn
      |> put_status(:ok)
      |> render(:update, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(StarBank.Users.Policy, :delete, current_user(conn), id),
         {:ok, %User{} = user} <- Users.delete(id) do
      conn
      |> put_status(:ok)
      |> render(:delete, user: user)
    end
  end

  def login(conn, params) do
    with {:ok, %User{} = user} <- Users.login(params) do
      token = Token.sign(user)

      conn
      |> put_status(:ok)
      |> render(:login, token: token)
    end
  end

  defp current_user(%Plug.Conn{assigns: %{user_id: id}}), do: %User{id: id}
  defp current_user(_), do: nil
end
