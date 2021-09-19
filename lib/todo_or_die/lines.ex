defmodule TodoOrDie.Lines do
  @tags ~w[TODO FIXME]

  alias TodoOrDie.Item

  def items_for(lines) do
    tags_string = "(#{Enum.join(@tags, "|")})"
    regex = Regex.compile!("(\\A|[^\\?])#\\s*#{tags_string}\\(([^\)]+)\\):?\\s*(.+)", "i")

    lines_with_index = Enum.with_index(lines)
    for {line, index} <- lines_with_index, result = line_match(line, regex), do: {result, index}
  end

  defp line_match(line, regex) do
    case Regex.run(regex, line) do
      nil -> nil
      [_, _, tag, expression, string] ->
        %Item{
          tag: String.to_atom(tag),
          expression: expression,
          string: string
        }
    end
  end
end
