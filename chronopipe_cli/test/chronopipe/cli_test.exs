defmodule Chronopipe.CLITest do
  use ExUnit.Case
  doctest Chronopipe.CLI

  test "greets the world" do
    assert Chronopipe.CLI.hello() == :world
  end
end
