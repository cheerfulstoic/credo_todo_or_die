defmodule TodoOrDie.Alert.Date do
  @moduledoc "Implementation of tags which alert on date passing"

  @behaviour TodoOrDie.Alert

  def message(string, context, options) do
    case Timex.parse(string, "{ISOdate}") do
      {:ok, datetime} ->
        {:ok, datetime} = DateTime.from_naive(datetime, options.timezone)
        {:ok, current_datetime} = DateTime.shift_zone(context.current_datetime, options.timezone)

        case Date.diff(DateTime.to_date(current_datetime), DateTime.to_date(datetime)) do
          diff when diff < 0 -> {:ok, nil}
          0 -> {:ok, "today is the day!"}
          1 -> {:ok, "1 day past"}
          diff -> {:ok, "#{diff} days past"}
        end

      {:error, message} ->
        {:error, message}
    end
  end
end
