defmodule StarBank.Users.Create do
  alias StarBank.Users.User
  alias StarBank.Repo
  alias StarBank.ViaCep.Client, as: ViaCepClient

  def call(%{"cep" => cep} = params) do
    with {:ok, _body} <- client().call(cep) do
      params
      |> User.changeset()
      |> Repo.insert()
    end
  end

  defp client() do
    Application.get_env(:star_bank, :via_cep_client, ViaCepClient)
  end
end
