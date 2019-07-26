defmodule Valkyrie.Standardizer.Json do
  @moduledoc false
  def standardize(_, value) do
    case Jason.encode(value) do
      {:ok, result} -> {:ok, result}
      _ -> {:error, :invalid_json}
    end
  end
end
