use Mix.Config

config :kafka_ex,
  use_ssl: false,
  disable_default_worker: true,
  consumer_group: :no_consumer_group
