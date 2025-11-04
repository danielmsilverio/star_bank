defmodule StarBankWeb.Token do
  alias Phoenix.Token
  alias StarBankWeb.Endpoint

  @sign_salt "star_bank_api"

  def sign(user) do
    Token.sign(Endpoint, @sign_salt, %{user_id: user.id})
  end

  def verify(token), do: Token.verify(Endpoint, @sign_salt, token)
end
