defmodule StarBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias StarBank.ViaCep.Client

  setup do
    bypass = Bypass.open()
    Application.put_env(:star_bank, :via_cep_url, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "when found cep, returns cep info", %{bypass: bypass} do
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

      Bypass.expect(bypass, "GET", "/12232090/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, JSON.encode!(body))
      end)

      cep = "12232090"

      response = Client.call(cep)
      assert response == {:ok, body}
    end

    test "when not found cep, returns not found", %{bypass: bypass} do
      body = ~s({
        "erro": "true"
      })

      Bypass.expect(bypass, "GET", "/12345678/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      cep = "12345678"

      response = Client.call(cep)

      assert response == {:error, :not_found}
    end

    test "when bad request, returns bad request", %{bypass: bypass} do
      body = ""

      Bypass.expect(bypass, "GET", "/11/json", fn conn ->
        Plug.Conn.resp(conn, 400, body)
      end)

      cep = "11"
      response = Client.call(cep)
      assert response == {:error, :bad_request}
    end
  end
end
