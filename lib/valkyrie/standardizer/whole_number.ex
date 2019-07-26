defmodule Valkyrie.Standardizer.Integer do
  @moduledoc false
  defdelegate standardize(field, value), to: Valkyrie.Standardizer.WholeNumber, as: :standardize
end

defmodule Valkyrie.Standardizer.Long do
  @moduledoc false
  defdelegate standardize(field, value), to: Valkyrie.Standardizer.WholeNumber, as: :standardize
end

defmodule Valkyrie.Standardizer.WholeNumber do
  @moduledoc false
  def standardize(_, value) when is_integer(value), do: {:ok, value}

  def standardize(%{type: type}, value) do
    case Integer.parse(value) do
      {parsed_value, ""} -> {:ok, parsed_value}
      _ -> {:error, :"invalid_#{type}"}
    end
  end
end
