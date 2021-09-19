defmodule TodoOrDie.Alert.Date do
  @behaviour TodoOrDie.Alert

  def alert?(string, context, options) do
    case Timex.parse(string, "{ISOdate}") do
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
    case Timex.parse(string, "{ISOdate}") do
      {:ok, datetime} ->
        {:ok, datetime} = DateTime.from_naive(datetime, options.timezone)
        {:ok, datetime} = DateTime.shift_zone(datetime, "Etc/UTC")

        case Date.diff(DateTime.to_date(context.current_datetime), DateTime.to_date(datetime)) do
          0 -> {:ok, "today is the day!"}
          1 -> {:ok, "1 day past"}
          diff -> {:ok, "#{diff} days past"}
        end

      {:error, message} -> {:error, message}
    end
  end
end



