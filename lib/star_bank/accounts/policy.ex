defmodule StarBank.Accounts.Policy do
  @behaviour Bodyguard.Policy

  alias StarBank.Users.User
  alias StarBank.Accounts
  alias StarBank.Accounts.Account

  # Only allow creating an account for yourself
  def authorize(:create, %User{id: subject_id}, %{"user_id" => user_id}) do
    if to_string(subject_id) == to_string(user_id) do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  # Only allow transactions from an account you own
  def authorize(:transaction, %User{id: subject_id}, %{"from_account_id" => acc_id}) do
    case Accounts.get(acc_id) do
      {:ok, %Account{user_id: ^subject_id}} -> :ok
      {:ok, %Account{}} -> {:error, :unauthorized}
      {:error, _} -> {:error, :not_found}
    end
  end

  def authorize(_action, _subject, _resource), do: {:error, :unauthorized}
end
