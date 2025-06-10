defmodule ClpCli do
  @moduledoc """
  Documentation for `ClpCli`.
  """
  def main(args) do
    case args do
      ["help"] -> show_help()
      ["clp_up"] -> run_playbook("clp_backend_up.yml")
      ["clp_down"] -> run_playbook("clp_backend_down.yml")
      _ -> show_help()
    end
  end

  defp show_help do
    IO.puts("""
    ChronoPipe CLI

    Usage:
      clp_cli clp_up     # Start backend services
      clp_cli clp_down   # Stop backend services
      clp_cli help       # Show this help message
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

      iex> ClpCli.hello()
      :world

  """
  def hello do
    :world
  end
end
