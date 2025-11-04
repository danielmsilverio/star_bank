defmodule StarBank.Users do
  alias StarBank.Users.Verify
  alias StarBank.Users.Create
  alias StarBank.Users.Get
  alias StarBank.Users.GetBy
  alias StarBank.Users.Update
  alias StarBank.Users.Delete

  defdelegate create(params), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate get_by(params), to: GetBy, as: :call
  defdelegate update(params), to: Update, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate login(params), to: Verify, as: :call
end
