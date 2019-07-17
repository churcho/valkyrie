defmodule Valkyrie.DatasetSupervisor do
  @moduledoc """
  Supervisor for each dataset that supervises the elsa producer and broadway pipeline.
  """
  use Supervisor

  def start_link(opts) do
    dataset = Keyword.fetch!(opts, :dataset)
    Supervisor.start_link(__MODULE__, opts, name: :"#{dataset.id}_supervisor")
  end

  @impl Supervisor
  def init(opts) do
    dataset = Keyword.fetch!(opts, :dataset)
    topic = Keyword.fetch!(opts, :topic)
    producer = :"#{dataset.id}_producer"

    children = [
      elsa_producer(dataset, topic, producer),
      broadway(dataset, topic, producer)
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  defp elsa_producer(dataset, topic, producer) do
    %{
      id: :"#{dataset.id}_elsa_producer",
      start: {Elsa.Producer.Manager, :start_producer, [endpoints(), outgoing_topic(dataset.id), [name: producer]]}
    }
  end

  defp broadway(dataset, topic, producer) do
    kafka_config = [
      dataset: dataset,
      producer: producer,
      name: :"#{dataset.id}_elsa_consumer",
      endpoints: endpoints(),
      group: "valkyrie-#{dataset.id}",
      topics: [topic],
      config: Application.get_env(:valkyrie, :topic_subscriber_config)
    ]

    {Valkyrie.Broadway, kafka_config}
  end

  defp endpoints(), do: Application.get_env(:valkyrie, :elsa_brokers)

  defp outgoing_topic_prefix(), do: Application.get_env(:valkyrie, :output_topic_prefix)
  defp outgoing_topic(dataset_id), do: "#{outgoing_topic_prefix()}-#{dataset_id}" |> IO.inspect(label: "outgoing_topic")
end
