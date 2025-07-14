defmodule SweetDate.ProtocolTest do
  use ExUnit.Case

  alias SweetDate.Protocol

  @valid_file "test/support/sample_protocol.json"

  test "load/1 returns {:ok, map} for valid protocol file" do
    assert {:ok, protocol} = Protocol.load(@valid_file)
    assert is_map(protocol)
    assert protocol["version"]
    assert protocol["namespaces"]
  end
end
