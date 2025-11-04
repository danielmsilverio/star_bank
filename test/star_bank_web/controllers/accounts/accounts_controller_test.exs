defmodule StarBankWeb.Accounts.AccountsControllerTest do
  use StarBankWeb.ConnCase

  import Mox

  alias StarBank.Accounts
  alias Accounts.Account
  alias StarBank.Users
  alias StarBankWeb.Token

  setup %{conn: conn} do
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

    params2 = %{
      "name" => "Silvério",
      "cep" => "12345678",
      "password" => "12345678",
      "email" => "silverio@teste.com"
    }

    {:ok, user2} = Users.create(params2)

    token = Token.sign(user1)
    authed_conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")

    {:ok, %{conn: authed_conn, user1: user1, user2: user2}}
  end

  describe "create/2" do
    test "when there are valid params, creates and return an account", %{conn: conn, user1: %{id: user_id}} do
      params = %{
        "balance" => 100,
        "user_id" => user_id
      }

      response =
        conn
        |> post(~p"/api/accounts", params)
        |> json_response(:created)

      assert %{
               "data" => %{"balance" => "100", "id" => _id, "user_id" => ^user_id},
               "message" => "Conta criada com sucesso"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, user1: user1} do
      params = %{
        "user_id" => user1.id
      }

      response =
        conn
        |> post(~p"/api/accounts", params)
        |> json_response(:bad_request)

      expected_response = %{"errors" => %{"balance" => ["can't be blank"]}}
      assert expected_response == response
    end

    test "when invalid user_id, returns unauthorized", %{conn: conn} do
      params = %{
        "balance" => 100,
        "user_id" => 99_999_999
      }

      response =
        conn
        |> post(~p"/api/accounts", params)
        |> json_response(:unauthorized)

      assert %{"status" => "unauthorized"} == response
    end
  end

  describe "transaction/2" do
    setup %{user1: user1, user2: user2} do
      {:ok, account1} = Accounts.create(%{"user_id" => user1.id, "balance" => 100})
      {:ok, account2} = Accounts.create(%{"user_id" => user2.id, "balance" => 100})
      {:ok, %{user1: user1, user2: user2, account1: account1, account2: account2}}
    end

    test "when there are valid params, creates and return a transaction", %{
      conn: conn,
      account1: %Account{id: account1_id},
      account2: %Account{id: account2_id}
    } do
      params = %{
        "from_account_id" => account1_id,
        "to_account_id" => account2_id,
        "value" => 40
      }

      response =
        conn
        |> post(~p"/api/accounts/transaction", params)
        |> json_response(:ok)

      assert %{
               "message" => "Transferencia realizada!",
               "from_account" => %{"balance" => "60", "id" => ^account1_id, "user_id" => _user1_id},
               "to_account" => %{"balance" => "140", "id" => ^account2_id, "user_id" => _user2_id}
             } = response
    end

    test "when there are value more than balance, returns an error", %{
      conn: conn,
      account1: %Account{id: account1_id},
      account2: %Account{id: account2_id}
    } do
      params = %{
        "from_account_id" => account1_id,
        "to_account_id" => account2_id,
        "value" => 8000
      }

      response =
        conn
        |> post(~p"/api/accounts/transaction", params)
        |> json_response(:bad_request)

      assert response == %{"errors" => %{"balance" => ["is invalid"]}}
    end

    test "when value is negative, returns invalid params", %{
      conn: conn,
      account1: %Account{id: account1_id},
      account2: %Account{id: account2_id}
    } do
      params = %{
        "from_account_id" => account1_id,
        "to_account_id" => account2_id,
        "value" => -10
      }

      response =
        conn
        |> post(~p"/api/accounts/transaction", params)
        |> json_response(:bad_request)

      assert response == %{"message" => "Valor inválido"}
    end
  end
end
