defmodule Kafka.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_kafka_helpers,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {Kafka.Application, []}]
  end

  defp deps do
    [
      {:kafka_ex, git: "https://github.com/dcuddeback/kafka_ex.git", branch: "feature/consumer-group"}
    ]
  end
end
