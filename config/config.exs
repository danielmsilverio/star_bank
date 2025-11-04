# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :star_bank,
  ecto_repos: [StarBank.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configura a URL base para o cliente ViaCep
config :star_bank, :via_cep_url, "https://viacep.com.br/ws"

# Configures the endpoint
config :star_bank, StarBankWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: StarBankWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: StarBank.PubSub,
  live_view: [signing_salt: "dumdzzi4"]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, disable_deprecated_builder_warning: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
