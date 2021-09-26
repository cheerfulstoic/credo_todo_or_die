defmodule TodoOrDie.Alert.Plain do
  @behaviour TodoOrDie.Alert

  def message("", _context, _options) do
    {:ok, ""}
  end
end
