defmodule StarBank.Accounts.Transactions do
  alias Ecto.Multi
  alias StarBank.Repo
  alias StarBank.Accounts
  alias Accounts.Account

  def call(%{"from_account_id" => from_account_id, "to_account_id" => to_account_id, "value" => value}) do
    with {:ok, from_account} <- get_account(from_account_id),
         {:ok, to_account} <- get_account(to_account_id),
         {:ok, value} <- cast_and_validate_value(value) do
      Multi.new()
      |> withdraw(from_account, value)
      |> deposit(to_account, value)
      |> Repo.transaction()
      |> handle_transaction()
    end
  end

  def call(_), do: {:error, "Invalid params"}

  defp get_account(id) do
    with {:ok, %Account{}} = account <- Accounts.get(id) do
      account
    else
      _err -> {:error, "Conta #{id} não encontrada."}
    end
  end

  defp cast_and_validate_value(value) do
    with {:ok, decimal_value} <- Decimal.cast(value),
         true <- Decimal.gt?(decimal_value, 0) do
      {:ok, decimal_value}
    else
      _err -> {:error, "Valor inválido"}
    end
  end

  defp withdraw(multi, from_account, value) do
    new_balance = Decimal.sub(from_account.balance, value)
    changeset = Account.changeset(from_account, %{balance: new_balance})
    Multi.update(multi, :withdraw, changeset)
  end

  defp deposit(multi, to_account, value) do
    new_balance = Decimal.add(to_account.balance, value)
    changeset = Account.changeset(to_account, %{balance: new_balance})
    Multi.update(multi, :deposit, changeset)
  end

  defp handle_transaction({:ok, _result} = result), do: result
  defp handle_transaction({:error, _op, reason, _}), do: {:error, reason}
end
