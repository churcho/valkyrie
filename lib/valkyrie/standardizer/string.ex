defmodule Valkyrie.Standardizer.String do
  def standardize(value) do
    {:ok, to_string(value)}
  rescue
    Protocol.UndefinedError -> {:error, :invalid_string}
  end
end
