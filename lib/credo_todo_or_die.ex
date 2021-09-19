defmodule CredoTodoOrDie do
  @moduledoc false

  alias Credo.Plugin

  @config_file :code.priv_dir(:credo_todo_or_die)
               |> Path.join(".credo.exs")
               |> File.read!()

  def init(exec) do
    Plugin.register_default_config(exec, @config_file)
  end
end
