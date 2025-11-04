defmodule StarBank.Users.Policy do
  @behaviour Bodyguard.Policy

  alias StarBank.Users.User

  # Allow a user to act only on their own user record
  def authorize(action, %User{id: subject_id}, resource) when action in [:show, :update, :delete] do
    resource_id = extract_id(resource)

    if to_string(subject_id) == to_string(resource_id) do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  def authorize(_action, _subject, _resource), do: {:error, :unauthorized}

  defp extract_id(%User{id: id}), do: id
  defp extract_id(%{"id" => id}), do: id
  defp extract_id(id), do: id
end
