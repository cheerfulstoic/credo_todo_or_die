defmodule TodoOrDie.Lines do
  alias TodoOrDie.Item

  def items_for(lines, tag_name) do
    regex = Regex.compile!("(\\A|[^\\?])#\\s*#{tag_name}(?:\\(([^)]+)\\))?:?\\s*(.+)", "i")

    lines_with_index = Enum.with_index(lines)

    for {line, index} <- lines_with_index,
        result = line_match(line, regex, tag_name),
        do: {result, index}
  end

  defp line_match(line, regex, tag_name) do
    case Regex.run(regex, line) do
      nil ->
        nil

      [_, _, expression, string] ->
        %Item{
          tag: String.to_atom(tag_name),
          expression: expression,
          string: String.trim(string)
        }
    end
  end
end
