defmodule TodoOrDie.AlertTest do
  use ExUnit.Case, async: true

  import Mox

  alias TodoOrDie.{Alert, Item}

  test "Date" do
    item = %Item{expression: "2021-02-15", tag: "TOTEST", string: "Test String"}

    options = %{timezone: "Etc/UTC"}

    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-14 12:00")}, options) ==
             nil

    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-15 12:00")}, options) ==
             "Found a TOTEST tag: Test String (today is the day!)"

    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-16 12:00")}, options) ==
             "Found a TOTEST tag: Test String (1 day past)"

    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-17 12:00")}, options) ==
             "Found a TOTEST tag: Test String (2 days past)"
  end

  test "DateTime" do
    item = %Item{expression: "2021-02-15 12:34", tag: "TOTEST", string: "Test String"}

    options = %{timezone: "Etc/UTC"}

    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-14 12:33")}, options) ==
             nil

    assert Alert.message(
             item,
             %{current_datetime: parse_datetime("2021-02-15 12:36:08")},
             options
           ) == "Found a TOTEST tag: Test String (2 minutes past)"

    assert Alert.message(item, %{current_datetime: parse_datetime("2021-02-16 12:35")}, options) ==
             "Found a TOTEST tag: Test String (1 day, 1 minute past)"
  end

  def assert_nil(value) do
    assert value == nil
  end

  describe "Package" do
    setup do
      [context: %{packages_module: CredoTodoOrDie.Packages.Mock}]
    end

    test "Just a version is specified", %{context: context} do
      mock_version(:some_package, "1.2.3", 3)

      message =
        %Item{expression: "some_package@1.2.3", tag: "TOTEST", string: "Test String"}
        |> Alert.message(context, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (some_package requirement `>=1.2.3` matched, current version: 1.2.3)"
      )

      %Item{expression: "some_package@1.2.4", tag: "TOTEST", string: "Test String"}
      |> Alert.message(context, %{})
      |> assert_nil()
    end

    test ">= is used", %{context: context} do
      mock_version(:some_package, "1.2.3", 6)

      message =
        %Item{expression: "some_package@>=1.2.3", tag: "TOTEST", string: "Test String"}
        |> Alert.message(context, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (some_package requirement `>=1.2.3` matched, current version: 1.2.3)"
      )

      message =
        %Item{expression: "some_package@>=1.2.2", tag: "TOTEST", string: "Test String"}
        |> Alert.message(context, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (some_package requirement `>=1.2.2` matched, current version: 1.2.3)"
      )

      message =
        %Item{expression: "some_package@>=1.1.4", tag: "TOTEST", string: "Test String"}
        |> Alert.message(context, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (some_package requirement `>=1.1.4` matched, current version: 1.2.3)"
      )

      message =
        %Item{expression: "some_package@>=0.3.4", tag: "TOTEST", string: "Test String"}
        |> Alert.message(context, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (some_package requirement `>=0.3.4` matched, current version: 1.2.3)"
      )

      %Item{expression: "some_package@>=1.2.4", tag: "TOTEST", string: "Test String"}
      |> Alert.message(context, %{})
      |> assert_nil()
    end

    test "~= is used", %{context: context} do
      mock_version(:some_package, "1.2.3", 6)

      message =
        %Item{expression: "some_package@~>1.2.3", tag: "TOTEST", string: "Test String"}
        |> Alert.message(context, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (some_package requirement `~>1.2.3` matched, current version: 1.2.3)"
      )

      message =
        %Item{expression: "some_package@~>1.2.2", tag: "TOTEST", string: "Test String"}
        |> Alert.message(context, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (some_package requirement `~>1.2.2` matched, current version: 1.2.3)"
      )

      %Item{expression: "some_package@~>1.2.4", tag: "TOTEST", string: "Test String"}
      |> Alert.message(context, %{})
      |> assert_nil()

      %Item{expression: "some_package@~>1.1.4", tag: "TOTEST", string: "Test String"}
      |> Alert.message(context, %{})
      |> assert_nil()

      %Item{expression: "some_package@~>0.3.4", tag: "TOTEST", string: "Test String"}
      |> Alert.message(context, %{})
      |> assert_nil()
    end

    test "Another package", %{context: context} do
      mock_version(:some_other_package, "3.2.1", 3)

      message =
        %Item{expression: "some_other_package@3.2.1", tag: "TOTEST", string: "Test String"}
        |> Alert.message(context, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (some_other_package requirement `>=3.2.1` matched, current version: 3.2.1)"
      )

      %Item{expression: "some_other_package@3.2.2", tag: "TOTEST", string: "Test String"}
      |> Alert.message(context, %{})
      |> assert_nil()
    end

    def mock_version(package, version, times \\ 1) do
      CredoTodoOrDie.Packages.Mock
      |> expect(:version, times, fn ^package -> version end)
    end

    defp parse_datetime(string) do
      {:ok, datetime} = Timex.parse(string, "{ISO:Extended}")
      {:ok, datetime} = DateTime.from_naive(datetime, "Etc/UTC")

      datetime
    end
  end

  describe "GitHub issue" do
    test "Should alert when an issue has been closed" do
      HTTPoison.Base.Mock
      |> expect(:get, fn
        "https://api.github.com/repos/user123/repo321/issues/1234" ->
          {:ok, %HTTPoison.Response{body: ~s({"state":"closed"}), status_code: 200}}
      end)

      message =
        %Item{expression: "user123/repo321#1234", tag: "TOTEST", string: "Test String"}
        |> Alert.message(%{httpoison_module: HTTPoison.Base.Mock}, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (issue #1234 in repo user123/repo321 has been closed)"
      )
    end

    test "Should not alert when an issue is open" do
      HTTPoison.Base.Mock
      |> expect(:get, fn
        "https://api.github.com/repos/user123/repo321/issues/1234" ->
          {:ok, %HTTPoison.Response{body: ~s({"state":"open"}), status_code: 200}}
      end)

      %Item{expression: "user123/repo321#1234", tag: "TOTEST", string: "Test String"}
      |> Alert.message(%{httpoison_module: HTTPoison.Base.Mock}, %{})
      |> assert_nil()
    end

    test "Should deal with non-200 response" do
      HTTPoison.Base.Mock
      |> expect(:get, fn
        "https://api.github.com/repos/user123/repo321/issues/1234" ->
          {:ok, %HTTPoison.Response{body: ~s({"error":"dunno"}), status_code: 500}}
      end)

      message =
        %Item{expression: "user123/repo321#1234", tag: "TOTEST", string: "Test String"}
        |> Alert.message(%{httpoison_module: HTTPoison.Base.Mock}, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (WAS UNABLE TO CHECK THE ISSUE - HTTP STATUS 500)"
      )
    end

    test "Should deal with connection errors" do
      HTTPoison.Base.Mock
      |> expect(:get, fn
        "https://api.github.com/repos/user123/repo321/issues/1234" ->
          {:error, %HTTPoison.Error{id: nil, reason: {:tls_alert, 'internal error'}}}
      end)

      message =
        %Item{expression: "user123/repo321#1234", tag: "TOTEST", string: "Test String"}
        |> Alert.message(%{httpoison_module: HTTPoison.Base.Mock}, %{})

      assert(
        message ==
          "Found a TOTEST tag: Test String (WAS UNABLE TO CHECK THE ISSUE - GOT ERROR: `{:tls_alert, ~c\"internal error\"}`)"
      )
    end
  end
end
