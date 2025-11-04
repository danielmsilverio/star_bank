defmodule StarBank.Accounts do
  alias StarBank.Accounts.Create
  alias StarBank.Accounts.Get
  alias StarBank.Accounts.Transactions

  defdelegate create(params), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate transaction(params), to: Transactions, as: :call
end
