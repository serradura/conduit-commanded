use Mix.Config

# Configure your database
config :conduit, Conduit.Repo,
  database: "conduit_test",
  hostname: "localhost",
  pool_size: 1

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  database: "conduit_eventstore_test",
  hostname: "localhost",
  pool_size: 1

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conduit, ConduitWeb.Endpoint,
  http: [port: 4002],
  server: false

config :conduit, consistency: :strong

# Print only warnings and errors during test
config :logger, level: :warn
