defmodule Valkyrie.Standardizer.Json do
  def standardize(value) do
    case Jason.encode(value) do
      {:ok, result} -> {:ok, result}
      _ -> {:error, :invalid_json}
    end
  end
end
