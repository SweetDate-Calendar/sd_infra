defmodule Clp.ConfigTest do
  use ExUnit.Case, async: true

  alias Clp.Config

  @tag :tmp_dir
  test "resolve_paths/1 loads paths for target language", %{tmp_dir: tmp_dir} do
    config_file = Path.join(tmp_dir, "clp.config.json")

    File.write!(config_file, ~s({
      "protocol": "protocol/protocol.json",
      "targets": {
        "ruby": {
          "output": "out/ruby"
        }
      }
    }))

    File.cd!(tmp_dir, fn ->
      assert {:ok, paths} = Config.resolve_paths("ruby")
      assert paths.language == "ruby"
      assert String.ends_with?(paths.protocol_path, "protocol/protocol.json")
      assert String.ends_with?(paths.output_path, "out/ruby")
    end)
  end
end
