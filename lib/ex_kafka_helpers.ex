defmodule Kafka do
  def produce(topic, message) do
    # TODO: Round robin over all partitions.
    partition = 0

    with :ok <- KafkaEx.produce(topic, partition, message) do
      :ok
    else
      _ -> :error
    end
  end
end
