defmodule Clp do
  @moduledoc """
  Documentation for `Clp`.
  """
  def main(args) do
    case args do
      ["help"] -> show_help()
      ["engine", "up"] -> run_playbook("clp_engine_up.yml")
      ["engine", "down"] -> run_playbook("clp_engine_down.yml")
      ["engine", "run"] -> run_playbook("clp_engine_run.yml")
      ["engine", "stop"] -> run_playbook("clp_engine_stop.yml")
      _ -> show_help()
    end
  end

  defp show_help do
    IO.puts("""
    ChronoPipe CLI

    Usage:
      clp engine up     # Start Docker container for the clp_engine
      clp engine down   # Stop Docker container for the clp_engine
      clp engine run    # Start Docker container and clp_engine
      clp engine stop   # Stop Docker container and clp_engine
      clp help           # Show this help message
    """)
  end

  defp run_playbook(playbook) do
    {output, status} =
      System.cmd("ansible-playbook", ["-i", "inventory.yml", playbook], cd: "../ansible")

    IO.puts(output)

    if status != 0 do
      IO.puts("""
      ❌ Failed running #{playbook}
      """)

      System.halt(status)
    end
  end

  @doc """
  Hello world.

  ## Examples

      iex> Clp.hello()
      :world

  """
  def hello do
    :world
  end
end
