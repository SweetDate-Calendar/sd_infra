defmodule Chronopipe.CLI do
  def main(["dev", "up" | rest]) do
    except_arg =
      case parse_except(rest) do
        nil -> ""
        services -> " -e \"skip_roles=#{services}\""
      end

    cmd = "ansible-playbook -i ../ansible/inventory.yml ../ansible/local_dev_up.yml#{except_arg}"
    IO.puts("🔧 Running: #{cmd}")
    System.cmd("sh", ["-c", cmd], into: IO.stream(:stdio, :line))
  end

  def main(["dev", "down"]) do
    cmd = "ansible-playbook -i ../ansible/inventory.yml ../ansible/local_dev_down.yml"
    IO.puts("🔧 Running: #{cmd}")
    System.cmd("sh", ["-c", cmd], into: IO.stream(:stdio, :line))
  end

  def main(["help"]) do
    IO.puts("""
    Chronopipe CLI

    Available commands:
      chronopipe dev up [--except|-e "role1,role2"]  # Start dev environment, optionally skip roles
      chronopipe dev down                           # Stop dev environment
      chronopipe help                               # Show this help message
    """)
  end

  def main(_) do
    IO.puts("Unknown command. Use 'chronopipe help' to see available commands.")
  end

  defp parse_except(["--except", services]), do: services
  defp parse_except(["-e", services]), do: services
  defp parse_except(_), do: nil

  @doc """
  Hello world.

  ## Examples

      iex> Chronopipe.CLI.hello()
      :world

  """
  def hello do
    :world
  end
end
