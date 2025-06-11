defmodule Clp.Scaffold.ElixirWrapper do
  alias Clp.{Config, Protocol}

  def run do
    with {:ok, paths} <- Config.resolve_paths("elixir"),
         {:ok, protocol} <- Protocol.load(paths.protocol_path) do
      Enum.each(protocol["namespaces"], fn {namespace, defn} ->
        generate_module_file(paths.output_path, namespace, defn["commands"])
      end)
    end
  end

  defp generate_module_file(output_path, namespace, commands) do
    module_name = "Clp." <> classify(namespace)
    file_name = Macro.underscore(module_name) <> ".ex"
    file_path = Path.join(output_path, file_name)

    content = generate_module(module_name, namespace, commands)

    File.mkdir_p!(Path.dirname(file_path))
    File.write!(file_path, content)
    IO.puts("✔︎ Wrote wrapper #{file_path}")
  end

  defp generate_module(module_name, namespace, commands) do
    methods =
      Enum.map(commands, fn {command, _} ->
        """
        def #{normalize_fn_name(command)}(params) do
          # TODO: implement #{namespace}.#{command}
        end
        """
      end)

    body = Enum.join(methods, "\n\n") |> indent(2)

    """
    defmodule #{module_name} do
    #{body}
    end
    """
  end

  defp classify(name) do
    name
    |> String.downcase()
    |> trim_plural()
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join()
  end

  defp trim_plural(name) do
    name
    |> String.downcase()
    |> String.replace_suffix("s", "")
  end

  defp normalize_fn_name(name) do
    name
    |> String.downcase()
    |> String.split("_")
    |> Enum.map(&String.trim/1)
    |> Enum.join("_")
  end

  defp indent(text, spaces) do
    prefix = String.duplicate(" ", spaces)

    text
    |> String.split("\n")
    |> Enum.map(&(prefix <> &1))
    |> Enum.join("\n")
  end
end
