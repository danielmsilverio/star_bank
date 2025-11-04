Mox.defmock(StarBank.ViaCep.ClientMock, for: StarBank.ViaCep.ClientBehaviour)
Application.put_env(:star_bank, :via_cep_client, StarBank.ViaCep.ClientMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(StarBank.Repo, :manual)
