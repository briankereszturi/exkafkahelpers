use Mix.Config

config :kafka_ex,
  brokers: [
    {"localhost", 9092}
  ],
  use_ssl: false,
  disable_default_worker: true,
  consumer_group: "kafka_ex"

