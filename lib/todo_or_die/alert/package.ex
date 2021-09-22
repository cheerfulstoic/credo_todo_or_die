defmodule TodoOrDie.Alert.Package do
  @behaviour TodoOrDie.Alert

  def alert?(string, context, options) do
    package = package(string, context)

    Version.match?(package.current_version, package.requirement)
  end

  def message(string, context, options) do
    package = package(string, context)

    {:ok, "#{package.name} requirement `#{package.requirement}` matched, current version: #{package.current_version}"}
  end

  defp package(string, context) do
    [name, requirement] = String.split(string, "@")

    requirement = if(String.match?(requirement, ~r/\A[>~=]/), do: requirement, else: ">=#{requirement}")

    current_version =
      name
      |> String.to_atom()
      |> context.packages_module.version()

    %{name: name, requirement: requirement, current_version: current_version}
  end
end




