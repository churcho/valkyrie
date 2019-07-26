defmodule Valkyrie.Standardizer.Timestamp do
  defdelegate standardize(field, value), to: Valkyrie.Standardizer.Date, as: :standardize
end

defmodule Valkyrie.Standardizer.Date do
  def standardize(%{type: type, format: format}, value) do
    case Timex.parse(value, format) do
      {:ok, parsed_value} -> {:ok, parsed_value}
      {:error, reason} -> {:error, {:"invalid_#{type}", reason}}
    end
  end
end
