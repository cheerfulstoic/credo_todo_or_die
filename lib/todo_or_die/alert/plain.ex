defmodule TodoOrDie.Alert.Plain do
  @behaviour TodoOrDie.Alert

  def alert?(string, context, options) do
    true
  end

  def message("", context, options) do
    {:ok, ""}
  end
end




