# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :conduit,
  ecto_repos: [Conduit.Repo]

# Configures the endpoint
config :conduit, ConduitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Qv1WPgJYkeIq2KpoQApT7aIhUezXg4ZvzYa+fqDsrTVUW4j3NCLa1k/4z0uea2zQ",
  render_errors: [view: ConduitWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Conduit.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Conduit.Repo

config :vex,
  sources: [
    Conduit.Support.Validators,
    Vex.Validators
  ]

config :comeonin, :bcrypt_log_rounds, 4

config :conduit, ConduitWeb.Auth.Guardian,
  issuer: "conduit",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "Yghh/vW0f9Ch1x1QEYg1sm/LwumbiNFMXyEPUVkRhwIk55ehPZhZqjlfsDFZOn02"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
