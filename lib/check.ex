defmodule CredoTodoOrDie.Check do
  @moduledoc "DO THIS!"
  use Credo.Check,
    param_defaults: [timezone: "Etc/UTC", tag_name: "TODO"],
    category: :design,
    explanations: [
      params: [
        tag_name: "The tag to look for (TODO/FIXME/NOTE/etc...)",
        timezone: """
          When specifing date/time you can specify the timezone of your development / CI machine
          so that it reports as accurately as possible

          Timezone can be anything specified in Timex.is_valid_timezone?
          https://hexdocs.pm/timex/Timex.html#is_valid_timezone?/1
        """
      ]
    ]

  def run(%Credo.SourceFile{} = source_file, params) do
    Application.ensure_all_started(:timex)

    issue_meta = IssueMeta.for(source_file, params)

    tag_name = Keyword.get(params, :tag_name, "TODO")

    source_file
    |> items_with_index(tag_name, params)
    |> Enum.map(&issue_for(issue_meta, &1, params))
  end

  defp issue_for(issue_meta, {item, line_no}, params) do
    format_issue(
      issue_meta,
      message: TodoOrDie.Alert.message(item, context(params), alert_options(params)),
      line_no: line_no # ,
      # trigger: trigger
    )
  end

  def items_with_index(source_file, tag_name, params) do
    # items_with_index_from_module_attributes(source_file, tag_name, include_doc?) ++
      items_with_index_from_comments(source_file, tag_name, params)
  end

  defp items_with_index_from_comments(source_file, tag_name, params) do
    alert_options = alert_options(params)

    Credo.SourceFile.source(source_file)
    |> Credo.Code.clean_charlists_strings_and_sigils()
    |> String.split("\n")
    |> TodoOrDie.Lines.items_for(tag_name)
    |> Enum.filter(fn {item, line_no} ->
      TodoOrDie.Alert.alert?(item, context(params), alert_options)
    end)
  end

  def alert_options(params) do
    timezone = Keyword.get(params, :timezone, "Etc/UTC")
    if !Timex.is_valid_timezone?(timezone) do
      raise "credo_todo_or_time: timezone specified is invalid: #{timezone}"
    end

    %{timezone: timezone}
  end

  # Passing in `current_datetime` as a param is only for tests
  def context(params) do
    current_datetime = Keyword.get(params, :current_datetime, DateTime.utc_now())

    if current_datetime.zone_abbr != "UTC" do
      raise "current_datetime must always be UTC!"
    end

    %{
      current_datetime: current_datetime
    }
  end
end
