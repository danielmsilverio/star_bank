defmodule StarBank.Users.Verify do
  alias StarBank.Users
  alias Users.User

  def call(%{"email" => email, "password" => password}) do
    case Users.get_by(%{"email" => email}) do
      {:ok, user} -> verify(user, password)
      {:error, _} = error -> error
    end
  end

  defp verify(%User{password_hash: hash} = user, password) do
    case Argon2.verify_pass(password, hash) do
      true -> {:ok, user}
      false -> {:error, :unauthorized}
    end
  end
end
