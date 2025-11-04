defmodule StarBank.Accounts.Get do
  alias StarBank.Accounts.Account
  alias StarBank.Repo

  def call(id) do
    case Repo.get(Account, id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end
end
