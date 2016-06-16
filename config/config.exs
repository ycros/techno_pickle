# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :techno_pickle,
  ecto_repos: [TechnoPickle.Repo]

# Configures the endpoint
config :techno_pickle, TechnoPickle.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KroHR4+YvoeV73H3lK2ycr/pxV855F5KkXt1Zg7Qh0+KVjd9XVBpamDzQrGiH2hF",
  render_errors: [view: TechnoPickle.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TechnoPickle.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
