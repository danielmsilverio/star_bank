defmodule StarBank.Accounts.Create do
  alias StarBank.Accounts.Account
  alias StarBank.Repo

  def call(params) do
    params
    |> Account.changeset()
    |> Repo.insert()
  end
end
