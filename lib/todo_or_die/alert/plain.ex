defmodule TodoOrDie.Alert.Plain do
  @behaviour TodoOrDie.Alert

  def alert?(_string, _context, _options) do
    true
  end

  def message("", _context, _options) do
    {:ok, ""}
  end
end
