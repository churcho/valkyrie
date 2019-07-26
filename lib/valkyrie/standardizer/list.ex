defmodule Valkyrie.Standardizer.List do
  def standardize(%{type: "list"}, value) when not is_list(value), do: {:error, :invalid_list}

  def standardize(%{type: "list"} = field, value) do
    case standardize_list(field, value) do
      {:ok, reversed_list} -> {:ok, Enum.reverse(reversed_list)}
      {:error, reason} -> {:error, {:invalid_list, reason}}
    end
  end

  def standardize_list(%{itemType: item_type} = field, value) do
    value
    |> Enum.with_index()
    |> Enum.reduce_while({:ok, []}, fn {item, index}, {:ok, acc} ->
      case Valkyrie.standardize(%{type: item_type, subSchema: field[:subSchema]}, item) do
        {:ok, new_value} -> {:cont, {:ok, [new_value | acc]}}
        {:error, reason} -> {:halt, {:error, "#{inspect(reason)} at index #{index}"}}
      end
    end)
  end
end
