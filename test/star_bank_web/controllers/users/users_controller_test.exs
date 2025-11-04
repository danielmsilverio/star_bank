defmodule StarBankWeb.Users.UsersControllerTest do
  use StarBankWeb.ConnCase

  import Mox

  alias StarBank.Users
  alias Users.User
  alias StarBankWeb.Token

  describe "create/2" do
    test "when there are valid params, creates and return an user", %{conn: conn} do
      params = %{
        "name" => "Daniel",
        "cep" => "12232090",
        "password" => "11111111",
        "email" => "daniel@teste.com"
      }

      body = %{
        "bairro" => "Bosque dos Eucaliptos",
        "cep" => "12232-090",
        "complemento" => "",
        "ddd" => "12",
        "estado" => "São Paulo",
        "gia" => "6452",
        "ibge" => "3549904",
        "localidade" => "São José dos Campos",
        "logradouro" => "Rua Alfredo Coslop",
        "regiao" => "Sudeste",
        "siafi" => "7099",
        "uf" => "SP",
        "unidade" => ""
      }

      expect(StarBank.ViaCep.ClientMock, :call, fn "12232090" ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"cep" => "12232090", "email" => "daniel@teste.com", "id" => _, "name" => "Daniel"},
               "message" => "Usuário criado com sucesso"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{
        "name" => "Daniel",
        "cep" => "12345678"
      }

      expect(StarBank.ViaCep.ClientMock, :call, fn "12345678" ->
        {:ok, ""}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response = %{"errors" => %{"email" => ["can't be blank"], "password" => ["can't be blank"]}}
      assert expected_response == response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      stub(StarBank.ViaCep.ClientMock, :call, fn _ ->
        {:ok, ""}
      end)

      {:ok, authed_user} =
        Users.create(%{
          "name" => "Auth User",
          "cep" => "12345678",
          "password" => "12345678",
          "email" => "auth@teste.com"
        })

      token = Token.sign(authed_user)
      authed_conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, %{conn: authed_conn, authed_user: authed_user}}
    end

    test "when have valid id, deletes an user", %{
      conn: conn,
      authed_user: %User{id: id, cep: cep, email: email, name: name}
    } do
      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"cep" => cep, "email" => email, "id" => id, "name" => name},
        "message" => "Usuário deletado com sucesso"
      }

      assert expected_response == response
    end

    test "when have invalid id, returns unauthorized", %{conn: conn} do
      response =
        conn
        |> delete(~p"/api/users/99999999")
        |> json_response(:unauthorized)

      expected_response = %{"status" => "unauthorized"}
      assert expected_response == response
    end
  end
end
