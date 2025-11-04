defmodule StarBank.Users.GetBy do
  alias StarBank.Repo
  alias StarBank.Users.User

  @fields_filtered [:id, :name, :email, :cep]

  def call(params) do
    query_params = filtered(params)

    case Repo.get_by(User, query_params) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  defp filtered(params) do
    params
    |> Map.take(@fields_filtered)
    |> Enum.reject(fn {_k, v} -> is_nil(v) or v == "" end)
    |> Enum.into(%{})
  end
end
