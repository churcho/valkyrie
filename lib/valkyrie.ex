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

  def standardize(field, value) do
    invoke_standardizer_based_on_type(field, value)
  end

  defp invoke_standardizer_based_on_type(%{type: type} = field, value) do
    module = :"Elixir.Valkyrie.Standardizer.#{String.capitalize(type)}"
    apply(module, :standardize, [field, value])
  rescue
    UndefinedFunctionError -> {:error, :invalid_type}
  end
end
