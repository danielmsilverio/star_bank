import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :star_bank, StarBank.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "star_bank_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :star_bank, StarBankWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "e3Att/GX9c7PtAJAVY0DoB6H0l6pUNr/JmedYCGxaksFuKyTipaoR/OHeqCDW1zF",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

# Fornece um valor padrão para a URL do ViaCep em testes.
# Isso força os testes a sobrescreverem ativamente com a URL do Bypass.
config :star_bank, :via_cep_url, "http://localhost:1"
