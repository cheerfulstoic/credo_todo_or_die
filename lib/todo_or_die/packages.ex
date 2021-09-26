defmodule CredoTodoOrDie.Packages do
  @moduledoc "Behavior for getting package versions"

  @callback version(atom()) :: String.t()
end
