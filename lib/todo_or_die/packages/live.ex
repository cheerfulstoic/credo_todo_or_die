defmodule CredoTodoOrDie.Packages.Live do
  @behaviour CredoTodoOrDie.Packages

  def version(package) do
    Application.spec(package, :vsn)
    |> List.to_string()
  end
end
