defmodule StarBankWeb.WelcomeController do
  use StarBankWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Bem vindo ao StarBank"})
  end
end
