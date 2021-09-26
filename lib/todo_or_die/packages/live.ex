defmodule CredoTodoOrDie.Packages.Live do
  @moduledoc "Real implementation of module to get package versions"

  @behaviour CredoTodoOrDie.Packages

  def version(package) do
    Application.spec(package, :vsn)
    |> List.to_string()
  end
end
