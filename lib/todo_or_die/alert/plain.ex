defmodule TodoOrDie.Alert.Plain do
  @moduledoc "Implementation of plain tags (without expressions)"

  @behaviour TodoOrDie.Alert

  def message("", _context, _options) do
    {:ok, ""}
  end
end
