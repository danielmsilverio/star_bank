defmodule StarBank.Accounts.TransactionsTest do
  use StarBank.DataCase

  import Mox

  alias StarBank.Accounts.Transactions
  alias StarBank.Accounts
  alias Accounts.Account
  alias StarBank.Users

  setup do
    stub(StarBank.ViaCep.ClientMock, :call, fn _ ->
      {:ok, ""}
    end)

    params1 = %{
      "name" => "Daniel",
      "cep" => "12345678",
      "password" => "12345678",
      "email" => "daniel@teste.com"
    }

    {:ok, user1} = Users.create(params1)
    {:ok, account1} = Accounts.create(%{"user_id" => user1.id, "balance" => 100})

    params2 = %{
      "name" => "Silvério",
      "cep" => "12345678",
      "password" => "12345678",
      "email" => "silverio@teste.com"
    }

    {:ok, user2} = Users.create(params2)
    {:ok, account2} = Accounts.create(%{"user_id" => user2.id, "balance" => 100})

    {:ok, %{user1: user1, user2: user2, account1: account1, account2: account2}}
  end

  describe "call/1" do
    test "when valid params, return ok and result", %{account1: account1, account2: account2} do
      params = %{"from_account_id" => account1.id, "to_account_id" => account2.id, "value" => 40}

      assert {:ok, result} = Transactions.call(params)

      assert %{deposit: %Account{balance: balance_after_deposit}} = result
      assert %{withdraw: %Account{balance: balance_after_withdraw}} = result

      assert balance_after_deposit == Decimal.new("140")
      assert balance_after_withdraw == Decimal.new("60")
    end

    test "when account_id is invalid, returns error message", %{account1: account1} do
      params = %{"from_account_id" => 99_999_999, "to_account_id" => account1.id, "value" => 40}

      assert {:error, reason} = Transactions.call(params)
      assert "Conta 99999999 não encontrada." == reason

      params = %{"to_account_id" => 99_999_999, "from_account_id" => account1.id, "value" => 40}
      assert {:error, reason} = Transactions.call(params)
      assert "Conta 99999999 não encontrada." == reason
    end

    test "when value is invalid, returns error message", %{account1: account1, account2: account2} do
      params = %{"from_account_id" => account1.id, "to_account_id" => account2.id, "value" => -40}

      assert {:error, reason} = Transactions.call(params)
      assert "Valor inválido" == reason

      params = %{"from_account_id" => account1.id, "to_account_id" => account2.id, "value" => "abc"}
      assert {:error, reason} = Transactions.call(params)
      assert "Valor inválido" == reason
    end

    test "when balance is invalid, returns changeset with errors", %{account1: account1, account2: account2} do
      params = %{"from_account_id" => account1.id, "to_account_id" => account2.id, "value" => 200}

      assert {:error, %Ecto.Changeset{errors: _value}} = Transactions.call(params)
    end

    test "when invalid params, return error invalid params" do
      assert {:error, "Invalid params"} = Transactions.call(%{})
    end
  end
end
