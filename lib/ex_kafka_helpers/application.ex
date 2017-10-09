defmodule ExKafkaHelpers.Application do
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
    zookeeper_hosts = Application.get_env(:ex_kafka_helpers, :zookeeper_hosts)

    {:ok, pid} = :erlzk.connect(zookeeper_hosts, 30_000, [])
    {:ok, children} = :erlzk.get_children(pid, "/brokers/ids")

    brokers = Enum.map(children, fn c ->
      {:ok, {data, _stats}} = :erlzk.get_data(pid, "/brokers/ids/#{c}")
      {:ok, info} = Poison.decode(data)
      {info["host"], 9092}
    end)

    Logger.info "Discovered brokers #{inspect brokers}"

    :ok = :erlzk.close(pid)
    Logger.info "Disconnected from Zookeeper"

    Application.put_env(:kafka_ex, :brokers, brokers)

    case KafkaEx.create_worker(:kafka_ex) do
      {:ok, pid} ->
        Logger.info "Connected to Kafka."
        {:ok, pid}
      e ->
        Logger.error "Error connecting to Kafka: #{inspect e}"
        :timer.sleep(5000)
        # Wait and reconnect.
        Logger.info "Attempting to connect to Kafka..."
        connect()
    end
  end
end
