defmodule StarBankWeb.Accounts.AccountsController do
  use StarBankWeb, :controller
  alias Bodyguard
  alias StarBank.Accounts
  alias Accounts.Account
  alias StarBank.Users.User

  action_fallback StarBankWeb.FallbackController

  def create(conn, params) do
    with :ok <- Bodyguard.permit(StarBank.Accounts.Policy, :create, current_user(conn), params),
         {:ok, %Account{} = account} <- Accounts.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, account: account)
    end
  end

  def transaction(conn, params) do
    with :ok <- Bodyguard.permit(StarBank.Accounts.Policy, :transaction, current_user(conn), params),
         {:ok, transaction} <- Accounts.transaction(params) do
      conn
      |> put_status(:ok)
      |> render(:transaction, transaction: transaction)
    end
  end

  defp current_user(%Plug.Conn{assigns: %{user_id: id}}), do: %User{id: id}
  defp current_user(_), do: nil
end
