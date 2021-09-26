defmodule TodoOrDie.LinesTest do
  use ExUnit.Case, async: true

  alias TodoOrDie.{Lines, Item}

  test "Non-matching lines" do
    assert Lines.items_for([], "TODO") == []
    assert Lines.items_for([""], "TODO") == []
    assert Lines.items_for(["def foobar do"], "TODO") == []
    assert Lines.items_for(["1 + 5"], "TODO") == []
    assert Lines.items_for([" # Just a comment!"], "TODO") == []
  end

  test "Matching lines" do
    assert Lines.items_for([" # TODO(2021-09-14) Clean this up"], "TODO") ==
             [{%Item{tag: :TODO, expression: "2021-09-14", string: "Clean this up"}, 0}]

    assert Lines.items_for([" # TODO(2021-09-14 15:43) Clean this up"], "TODO") ==
             [{%Item{tag: :TODO, expression: "2021-09-14 15:43", string: "Clean this up"}, 0}]

    assert Lines.items_for([" def fun_name do", " # TODO(#1234) Clean this up"], "TODO") ==
             [{%Item{tag: :TODO, expression: "#1234", string: "Clean this up"}, 1}]

    assert Lines.items_for([" # TODO(something else!) Clean this up"], "TODO") ==
             [{%Item{tag: :TODO, expression: "something else!", string: "Clean this up"}, 0}]

    assert Lines.items_for([" # TODO: Plain TODO"], "TODO") ==
             [{%Item{tag: :TODO, expression: "", string: "Plain TODO"}, 0}]

    assert Lines.items_for([" # TODO Plain TODO"], "TODO") ==
             [{%Item{tag: :TODO, expression: "", string: "Plain TODO"}, 0}]

    assert Lines.items_for([" # RANDOM(2021-09-14) Clean this up"], "RANDOM") ==
             [{%Item{tag: :RANDOM, expression: "2021-09-14", string: "Clean this up"}, 0}]

    assert Lines.items_for([" # RANDOM Plain RANDOM"], "RANDOM") ==
             [{%Item{tag: :RANDOM, expression: "", string: "Plain RANDOM"}, 0}]
  end
end
