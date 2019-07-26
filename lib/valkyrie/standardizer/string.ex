defmodule Valkyrie.Standardizer.String do
  @moduledoc false
  def standardize(_, value) do
    {:ok, to_string(value)}
  rescue
    Protocol.UndefinedError -> {:error, :invalid_string}
  end
end
