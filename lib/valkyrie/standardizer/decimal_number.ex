defmodule Valkyrie.Standardizer.Float do
  defdelegate standardize(field, value), to: Valkyrie.Standardizer.DecimalNumber, as: :standardize
end

defmodule Valkyrie.Standardizer.Double do
  defdelegate standardize(field, value), to: Valkyrie.Standardizer.DecimalNumber, as: :standardize
end

defmodule Valkyrie.Standardizer.DecimalNumber do
  def standardize(_, value) when is_integer(value) or is_float(value) do
    {:ok, value / 1}
  end

  def standardize(type, value) do
    case Float.parse(value) do
      {parsed_value, ""} -> {:ok, parsed_value}
      _ -> {:error, :"invalid_#{type}"}
    end
  end
end
