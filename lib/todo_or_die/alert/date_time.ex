defmodule TodoOrDie.Alert.DateTime do
  @behaviour TodoOrDie.Alert

  def message(string, context, options) do
    case Timex.parse(string, "{ISO:Extended}") do
      {:ok, datetime} ->
        {:ok, datetime} = DateTime.from_naive(datetime, options.timezone)

        case DateTime.compare(context.current_datetime, datetime) do
          :lt ->
            {:ok, nil}

          _ ->
            duration_string =
              context.current_datetime
              |> Timex.diff(datetime)
              |> div(1_000_000 * 60)
              |> Timex.Duration.from_minutes()
              |> Timex.format_duration(:humanized)

            {:ok, "#{duration_string} past"}
        end

      {:error, message} ->
        {:error, message}
    end
  end
end
