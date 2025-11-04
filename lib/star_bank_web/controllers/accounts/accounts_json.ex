defmodule StarBankWeb.Accounts.AccountsJSON do
  alias StarBank.Accounts.Account

  def create(%{account: account}) do
    %{
      message: "Conta criada com sucesso",
      data: data(account)
    }
  end

  def transaction(%{transaction: %{deposit: to_account, withdraw: from_account}}) do
    %{
      message: "Transferencia realizada!",
      from_account: data(from_account),
      to_account: data(to_account)
    }
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      balance: account.balance,
      user_id: account.user_id
    }
  end
end
