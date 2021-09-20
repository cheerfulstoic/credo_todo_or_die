defmodule TodoOrDie.Alert.DateTime do
  @behaviour TodoOrDie.Alert

  def alert?(string, context, options) do
    case Timex.parse(string, "{ISO:Extended}") do
      {:ok, datetime} ->
        {:ok, datetime} = DateTime.from_naive(datetime, options.timezone, Tzdata.TimeZoneDatabase)

        case DateTime.compare(context.current_datetime, datetime) do
          :lt -> false
          _ -> true
        end

      {:error, _} -> true
    end
  end

  def message(string, context, options) do
    case Timex.parse(string, "{ISO:Extended}") do
      {:ok, datetime} ->
        {:ok, datetime} = DateTime.from_naive(datetime, options.timezone)

        duration_string =
          context.current_datetime
          |> Timex.diff(datetime)
          |> div(1_000_000 * 60)
          |> Timex.Duration.from_minutes()
          |> Timex.format_duration(:humanized)

        {:ok, "#{duration_string} past"}

      {:error, message} -> {:error, message}
    end
  end
end



