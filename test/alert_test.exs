defmodule TodoOrDie.AlertTest do
  use ExUnit.Case, async: true

  alias TodoOrDie.{Alert, Item}

  test "Date" do
    item = %Item{expression: "2021-02-15", tag: "TOTEST", string: "Test String"}

    options = %{timezone: "Etc/UTC"}

    assert Alert.alert?(item, %{current_datetime: parse_datetime("2021-02-14 12:00")}, options) == false
    assert Alert.alert?(item, %{current_datetime: parse_datetime("2021-02-15 12:00")}, options) == true
    assert Alert.alert?(item, %{current_datetime: parse_datetime("2021-02-16 12:00")}, options) == true

    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-15 12:00")}, options) == "Found a TOTEST tag: Test String (today is the day!)"
    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-16 12:00")}, options) == "Found a TOTEST tag: Test String (1 day past)"
    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-17 12:00")}, options) == "Found a TOTEST tag: Test String (2 days past)"
  end

  test "DateTime" do
    item = %Item{expression: "2021-02-15 12:34", tag: "TOTEST", string: "Test String"}

    options = %{timezone: "Etc/UTC"}

    assert Alert.alert?(item, %{current_datetime: parse_datetime("2021-02-14 12:33")}, options) == false
    assert Alert.alert?(item, %{current_datetime: parse_datetime("2021-02-15 12:34")}, options) == true
    assert Alert.alert?(item, %{current_datetime: parse_datetime("2021-02-16 12:35")}, options) == true

    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-15 12:34:08")}, options) == "Found a TOTEST tag: Test String (8 seconds past)"
    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-16 12:35")}, options) == "Found a TOTEST tag: Test String (1 day, 1 minute past)"
  end

  defp parse_datetime(string) do
    {:ok, datetime} = Timex.parse(string, "{ISO:Extended}")
    {:ok, datetime} = DateTime.from_naive(datetime, "Etc/UTC")

    datetime
  end
end


