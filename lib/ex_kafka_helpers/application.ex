defmodule Kafka.Application do
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [ worker(__MODULE__, [], function: :connect) ]

    opts = [strategy: :one_for_one, name: Kafka.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def connect() do
    case KafkaEx.create_worker(:kafka_ex) do
      {:ok, pid} -> {:ok, pid}
      _ ->
        :timer.sleep(5000)
        # Wait and reconnect.
        Logger.info "Attempting to connect to Kafka..."
        connect()
    end
  end
end
