defmodule StarBank.Repo do
  use Ecto.Repo,
    otp_app: :star_bank,
    adapter: Ecto.Adapters.Postgres
end
