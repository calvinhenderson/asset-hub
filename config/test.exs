import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :asset_hub, AssetHub.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "asset_hub_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web, Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "cUSVkthElADjPdzwwYHK9cwh24bmyAkRv218nhLpqTe9d11ednNeAmcj9+xxyyrl",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# In test we don't send emails.
config :asset_hub, AssetHub.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
