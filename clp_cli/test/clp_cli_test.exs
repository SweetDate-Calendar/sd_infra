defmodule ClpCliTest do
  use ExUnit.Case
  doctest ClpCli

  test "greets the world" do
    assert ClpCli.hello() == :world
  end
end
