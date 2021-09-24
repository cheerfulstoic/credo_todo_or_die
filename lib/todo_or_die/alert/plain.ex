defmodule TodoOrDie.Alert.Plain do
  @behaviour TodoOrDie.Alert

  def message("", context, options) do
    {:ok, ""}
  end
end




