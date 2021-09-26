defmodule TodoOrDie.Alert.Package do
  @moduledoc "Implementation of tags which alert on package version expressions"

  @behaviour TodoOrDie.Alert

  def message(string, context, _options) do
    package = package(string, context)

    if Version.match?(package.current_version, package.requirement) do
      {:ok,
       "#{package.name} requirement `#{package.requirement}` matched, current version: #{package.current_version}"}
    else
      {:ok, nil}
    end
  end

  defp package(string, context) do
    [name, requirement] = String.split(string, "@")

    requirement =
      if(String.match?(requirement, ~r/\A[>~=]/), do: requirement, else: ">=#{requirement}")

    current_version =
      name
      |> String.to_atom()
      |> context.packages_module.version()

    %{name: name, requirement: requirement, current_version: current_version}
  end
end
