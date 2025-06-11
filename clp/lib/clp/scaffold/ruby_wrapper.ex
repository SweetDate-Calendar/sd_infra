defmodule Clp.Scaffold.RubyWrapper do
  alias Clp.{Config, Protocol}

  def run do
    with {:ok, paths} <- Config.resolve_paths("ruby"),
         {:ok, protocol} <- Protocol.load(paths.protocol_path) do
      protocol["namespaces"]
      |> Enum.each(fn {namespace, defn} ->
        generate_wrapper_file(paths.output_path, namespace, defn["commands"])
      end)
    end
  end

  defp generate_wrapper_file(output_path, namespace, commands) do
    class_name = "Clp" <> classify(namespace)
    file_name = "clp_" <> String.downcase(trim_plural(namespace)) <> ".rb"
    file_path = Path.join(output_path, file_name)

    content = generate_class(class_name, namespace, commands)

    File.mkdir_p!(Path.dirname(file_path))
    File.write!(file_path, content)
    IO.puts("✔︎ Wrote wrapper #{file_path}")
  end

  defp generate_class(class_name, namespace, commands) do
    methods =
      Enum.map(commands, fn {command_name, _} ->
        method_name = normalize_method_name(command_name)

        """
        def self.#{method_name}(params)
          # TODO: implement #{namespace}.#{command_name}
        end
        """
      end)

    body = Enum.join(methods, "\n\n") |> indent(2)

    """
    class #{class_name}
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

  defp normalize_method_name(name) do
    name
    |> String.downcase()
    |> String.split("_")
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
