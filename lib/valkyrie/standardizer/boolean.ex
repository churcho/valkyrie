defmodule Valkyrie.Standardizer.Boolean do
  @moduledoc false
  def standardize(_, value) when is_boolean(value), do: {:ok, value}

  def standardize(_, value) do
    case value do
      "true" -> {:ok, true}
      "false" -> {:ok, false}
      _ -> {:error, :invalid_boolean}
    end
  end
end
