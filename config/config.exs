# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ats,
  ecto_repos: [Ats.Repo]

# Configures the endpoint
config :ats, AtsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tNv4rgLkV/3dF18vwQBbIJsNsNNby0dCePFhxkmypatiVxHKmI9UPwoNa+WdJRVO",
  render_errors: [view: AtsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Ats.PubSub,
  live_view: [signing_salt: "qBMAAW2E"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
