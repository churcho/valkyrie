defmodule Valkyrie.Standardizer.Map do
  @moduledoc false
  def standardize(_, value) when not is_map(value), do: {:error, :invalid_map}

  def standardize(%{subSchema: sub_schema}, value) do
    %{data: data, errors: errors} = Valkyrie.standardize_schema(sub_schema, value)

    case Enum.empty?(errors) do
      true -> {:ok, data}
      false -> {:error, errors}
    end
  end
end
