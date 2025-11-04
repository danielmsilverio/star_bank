defmodule StarBank.ViaCep.Client do
  alias StarBank.ViaCep.ClientBehaviour
  @behaviour ClientBehaviour

  @impl ClientBehaviour
  def call(cep) do
    base_url = Application.fetch_env!(:star_bank, :via_cep_url)

    middlewares = [
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BaseUrl, base_url}
    ]

    Tesla.client(middlewares)
    |> Tesla.get("/#{cep}/json")
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: %{"erro" => "true"}}}) do
    {:error, :not_found}
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({:ok, %Tesla.Env{status: 400}}) do
    {:error, :bad_request}
  end

  defp handle_response(_), do: {:error, :internal_error}
end
