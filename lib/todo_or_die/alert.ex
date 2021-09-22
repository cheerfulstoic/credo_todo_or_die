defmodule TodoOrDie.Alert do
  @callback alert?(String.t, Map.t, Map.t) :: boolean()
  @callback message(String.t, Map.t, Map.t) :: {:ok, String.t} | {:error, String.t}

  def alert?(item, context, options) do
    case module_for(item) do
      nil -> true
      module -> module.alert?(item.expression, context, options)
    end
  end

  def message(item, context, options) do
    case module_for(item) do
      nil -> "Invalid expression: #{item.expression}"

      module ->
        case module.message(item.expression, context, options) do
          {:ok, ""} ->
            "Found a #{item.tag} tag: #{item.string}"
          {:ok, message} ->
            "Found a #{item.tag} tag: #{item.string} (#{message})"
          {:error, message} ->
            "Invalid expression: #{message}"
        end
    end
  end

  defp module_for(item) do
    cond do
      String.match?(item.expression, ~r/\A\d\d\d\d-\d\d-\d\d\Z/) -> TodoOrDie.Alert.Date
      String.match?(item.expression, ~r/\A\d\d\d\d-\d\d-\d\d \d\d?:\d\d/) -> TodoOrDie.Alert.DateTime

      String.match?(item.expression, ~r/\A[^@]+@([>=~]+)?[\d\.]+\Z/) -> TodoOrDie.Alert.Package

      item.expression == "" -> TodoOrDie.Alert.Plain

      true -> nil
    end
  end
end


