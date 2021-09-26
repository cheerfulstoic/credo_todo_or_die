# CredoTodoOrDie

`credo_todo_or_die` is a library with a [`credo`](https://github.com/rrrene/credo) check to allow making notes in code which will fail at an appropriate time.  For example:

## Get a credo alert when a date/time has arrived:

```elixir
def get_user(id) do
  # TODO(2022-02-02) Fix this hack when the database migration is complete
  if id > 1_000_000 do
    v1_api_call()
  else
    v2_api_call()
  end
end
```

This will produce a credo alert on or after the day in question:

```
┃ [D] → Found a TODO tag: Fix this hack when the database migration is complete (2 days past)
┃       lib/my_app/users.ex:12 #(MyApp.Users)
```

It is also possible to specify a time with the date:

```
# TODO(2022-02-02 12:34:56) The time has come!
```

This can have a more precise description of how long it has been since the note's deadline has passed:

```
┃ [D] → Found a TODO tag: Fix this hack when the database migration is complete (1 week, 2 days, 6 hours, 16 minutes past)
┃       lib/my_app/users.ex:12 #(MyApp.Users)
```

## Get a credo alert when a package matches a version requirement

```
# TODO(phoenix@10.0.0) Use the new, cool stuff!
# TODO(phoenix@>=10.0.0) This is the same!

# TODO(jason@~> 2.0.0) Only triggers after 2.0.0 and before 2.1.0
```

Credo alerts will look like:

```
┃ [D] ↗ Found a TODO tag: Use the new, cool stuff! (phoenix requirement `>=10.0.0` matched, current version: 10.0.1)
┃       lib/my_app_web/controllers/user_controller.ex:22 #(MyAppWeb.UserController)
```

## Get a credo alert when a GitHub issue / pull request has been closed

```
# TODO(phoenixframework/phoenix#4321) Refactor when support has been added
```

Credo alerts will look like:

```
┃ [D] ↗ Found a TODO tag: Refactor when support has been added (issue #4321 in repo phoenixframework/phoenix has been closed)
┃       lib/my_app/user.ex:22 #(MyApp.User)
```

## Configuration

You can configure one or more versions of the plugin in your `.credo.exs` file:

```elixir
%{
  configs: [
    %{
      name: "default",
      checks: [
        {CredoTodoOrDie.Check, tag_name: "BUG", timezone: "Europe/Stockholm", priority: :higher},
        {CredoTodoOrDie.Check, tag_name: "FIXME", timezone: "Europe/Stockholm", priority: :high},
        {CredoTodoOrDie.Check, tag_name: "TODO", timezone: "Europe/Stockholm", priority: :normal},
        # Doesn't show up unless you use the `--strict` flag
        {CredoTodoOrDie.Check, tag_name: "NOTE", timezone: "Europe/Stockholm", priority: :low},

        # If you use `credo_todo_or_die` you'll probably want to disable these built-in checks
        # as it will cause duplicates
        # `credo_todo_or_die` will report standard notes (without parentheses) for the above `tag_name`s
        {Credo.Check.Design.TagTODO, false},
        {Credo.Check.Design.TagFIXME, false}
      ],
    }
  ]
}
```

The `timezone` param defaults to `"Etc/UTC"`.  It allows you to set the timezone of your development / CI machine for more accurate reporting of notes based on time.

## Caveats

While this checker is inspired by the ruby `todo_or_die` gem, it doesn't execute at runtime and can't do everything that gem can.  For example we can't fail on a condition defined by runtime code.

## Potential future improvements

 * Notes which reference a dependency version and alert when it has been reached ([see here](https://elixirforum.com/t/inspecting-dependency-package-version-at-runtime/24440/2))
 * Notes which reference an OTP / Elixir version and alert when it has been reached

 * Notes like `TODO(#1234) xxxxx` which can alert when a specific GitHub(/other) issue is closed

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `credo_todo_or_die` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:credo_todo_or_die, "~> 0.3.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/credo_todo_or_die](https://hexdocs.pm/credo_todo_or_die).

