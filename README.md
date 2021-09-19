# CredoTodoOrDie

`credo_todo_or_die` is a library with a [`credo`](https://github.com/rrrene/credo) check to allow making notes in code which will fail at an appropriate time.  For example:

## Get a credo alert when a date has arrived:

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

# TODO: EXAMPLE OF DATETIME

# TODO: SHOW EXAMPLE OUTPUTS

Since the code isn't run at runtime, we don't fail on just any conditions

## Params

# TODO: HOW TO SET PARAMS

# timezone (default to `"Etc/UTC"`).  Why config timezone?  Dev machine / CI server

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `credo_todo_or_die` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:credo_todo_or_die, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/credo_todo_or_die](https://hexdocs.pm/credo_todo_or_die).

