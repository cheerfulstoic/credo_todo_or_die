defmodule TodoOrDie.Alert do
  # TODO: Fix these
  @callback alert?(String.t) :: boolean()
  @callback message(String.t) :: boolean()

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

      true -> nil
    end
  end
end


