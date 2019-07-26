defmodule Valkyrie do
  @moduledoc """
  Main Business logic for Valkyrie
  Validating and transforming the payload to conform to the provided dataset schema
  """

  alias SmartCity.Dataset

  @type reason :: %{String.t() => term()}

  @spec standardize_data(%Dataset{}, map()) :: {:ok, map()} | {:error, reason()}
  def standardize_data(%Dataset{technical: %{schema: schema}}, payload) do
    %{data: data, errors: errors} = standardize_schema(schema, payload)

    case Enum.empty?(errors) do
      true -> {:ok, data}
      false -> {:error, errors}
    end
  end

  def standardize_schema(schema, payload) do
    schema
    |> Enum.reduce(%{data: %{}, errors: %{}}, fn %{name: name} = field, acc ->
      case standardize(field, payload[name]) do
        {:ok, value} -> %{acc | data: Map.put(acc.data, name, value)}
        {:error, reason} -> %{acc | errors: Map.put(acc.errors, name, reason)}
      end
    end)
  end

  def standardize(_field, nil), do: {:ok, nil}

  def standardize(%{type: "string"}, value), do: Valkyrie.Standardizer.String.standardize(value)

  def standardize(%{type: "json"}, value), do: Valkyrie.Standardizer.Json.standardize(value)

  def standardize(%{type: type}, value) when type in ["integer", "long"] do
    Valkyrie.Standardizer.WholeNumber.standardize(type, value)
  end

  def standardize(%{type: type}, value) when type in ["double", "float"] do
    Valkyrie.Standardizer.DecimalNumber.standardize(type, value)
  end

  def standardize(%{type: "boolean"}, value), do: Valkyrie.Standardizer.Boolean.standardize(value)

  def standardize(%{type: type, format: _} = field, value) when type in ["date", "timestamp"] do
    Valkyrie.Standardizer.Date.standardize(field, value)
  end

  def standardize(%{type: "map"} = field, value) do
    Valkyrie.Standardizer.Map.standardize(field, value)
  end

  def standardize(%{type: "list"} = field, value) do
    Valkyrie.Standardizer.List.standardize(field, value)
  end

  # defp standardize(%{type: type}, value) do
  #   module = :"Elixir.Valkyrie.Standardizer.#{String.capitalize(type)}"
  #   apply(module, :standardize, [value])
  # end
end
