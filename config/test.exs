use Mix.Config

# Configure your database
config :conduit, Conduit.Repo,
  database: "conduit_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  database: "conduit_eventstore_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conduit, ConduitWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
