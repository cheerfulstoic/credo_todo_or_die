defmodule CredoTodoOrDie.CheckTest do
  use Credo.Test.Case

  def assert_check_issue(code, message) do
    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check)
    |> assert_issue(fn issue ->
      assert issue.message == message
    end)
  end

  test "Invalid expressions" do
    "# TODO(2021-09-2) Do something!!"
    |> assert_check_issue("Invalid expression: 2021-09-2")

    "# TODO(Some text) Do something!!"
    |> assert_check_issue("Invalid expression: Some text")

    "# TODO(2020-15-01) Do something!!"
    |> assert_check_issue("Invalid expression: Expected `2 digit month` at line 1, column 6.")
  end

  test "Default behavior" do
    code =
      """
      defmodule CredoSampleModule do
        @somedoc "This is somedoc"

        # TODO(2021-09-20) Do something!!
      end
      """

    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check, current_datetime: ~U[2021-09-19 23:59:59.999999Z])
    |> refute_issues()

    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check, current_datetime: ~U[2021-09-20 00:00:00.000000Z])
    |> assert_issue(fn issue ->
      assert issue.message == "Found a TODO tag: Do something!! (today is the day!)"
      assert issue.category == :design
    end)

    code =
      """
      defmodule CredoSampleModule do
        @somedoc "This is somedoc"

        # TODO(2021-09-20 04:00) Do something!!
      end
      """

    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check, current_datetime: ~U[2021-09-20 03:59:59.999999Z])
    |> refute_issues()

    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check, current_datetime: ~U[2021-09-20 04:00:00.000000Z])
    |> assert_issue(fn issue ->
      assert issue.message == "Found a TODO tag: Do something!! (0 microseconds past)"
      assert issue.category == :design
    end)
  end

  test "Uses the timezone param" do
    code =
      """
      defmodule CredoSampleModule do
        @somedoc "This is somedoc"

        # TODO(2021-09-20) Do something!!
      end
      """

    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check, timezone: "Europe/Stockholm", current_datetime: ~U[2021-09-19 21:59:59.999999Z])
    |> refute_issues()

    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check, timezone: "Europe/Stockholm", current_datetime: ~U[2021-09-19 22:00:00.000000Z])
    |> assert_issue(fn issue ->
      assert issue.message == "Found a TODO tag: Do something!! (today is the day!)"
      assert issue.category == :design
    end)


    code =
      """
      defmodule CredoSampleModule do
        @somedoc "This is somedoc"

        # TODO(2021-09-20 04:00) Do something!!
      end
      """

    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check, timezone: "Europe/Stockholm", current_datetime: ~U[2021-09-19 01:59:59.999999Z])
    |> refute_issues()

    code
    |> to_source_file()
    |> run_check(CredoTodoOrDie.Check, timezone: "Europe/Stockholm", current_datetime: ~U[2021-09-20 02:00:00.000000Z])
    |> assert_issue(fn issue ->
      assert issue.message == "Found a TODO tag: Do something!! (0 microseconds past)"
      assert issue.category == :design
    end)

  end
end
