defmodule Valkyrie.Standardizer.Boolean do
  def standardize(value) when is_boolean(value), do: {:ok, value}

  def standardize(value) do
    case value do
      "true" -> {:ok, true}
      "false" -> {:ok, false}
      _ -> {:error, :invalid_boolean}
    end
  end
end
