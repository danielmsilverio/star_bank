defmodule StarBank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias StarBank.Users.User

  @required_params [:balance, :user_id]

  schema "accounts" do
    field :balance, :decimal
    belongs_to :user, User

    timestamps()
  end

  def changeset(account \\ %__MODULE__{}, params) do
    account
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id)
    |> check_constraint(:balance, name: :balance_must_be_positive)
    |> unique_constraint(:user_id, message: "Account already exists for this user")
  end
end
