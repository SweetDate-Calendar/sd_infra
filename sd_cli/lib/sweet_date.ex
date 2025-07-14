defmodule SweetDate do
  @moduledoc """
  Documentation for `SweetDate`.
  """
  def main(args) do
    case args do
      ["help"] -> show_help()
      ["scaffold", "ruby"] -> scaffold_ruby()
      ["scaffold", "elixir"] -> scaffold_elixir()
      _ -> show_help()
    end
  end

  defp show_help do
    IO.puts("""
    SweetDate CLI

    Usage:
      sweet_date scaffold ruby  # Scaffold basic ruby gem
      sweet_date scaffold elixir# Scaffold basic elixir hex package

      sd help           # Show this help message
    """)
  end

  defp scaffold_ruby do
    SweetDate.Scaffold.RubyWrapper.run()
  end

  defp scaffold_elixir do
    SweetDate.Scaffold.ElixirWrapper.run()
  end

  @doc """
  Hello world.

  ## Examples

      iex> SweetDate.hello()
      :world

  """
  def hello do
    :world
  end
end
