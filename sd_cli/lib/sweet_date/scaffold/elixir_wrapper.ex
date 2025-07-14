defmodule SweetDate.Scaffold.ElixirWrapper do
  alias SweetDate.Config

  def run do
    IO.puts("🔍 Starting ElixirWrapper.run/0")

    with {:ok, paths} <- Config.resolve_paths("elixir") do
      protocol = load_protocol(paths.protocol_path)

      protocol["namespaces"]
      |> Enum.each(fn {namespace, defn} ->
        generate_module_file(paths.output_path, namespace, defn["commands"])
      end)
    else
      {:error, reason} ->
        IO.puts("❌ Failed to resolve paths: #{inspect(reason)}")
    end
  end

  # Copy the same load_protocol logic from the Ruby wrapper
  defp load_protocol(path) do
    root = File.read!(path) |> Jason.decode!()

    includes =
      Map.get(root, "includes", [])
      |> Enum.map(fn file ->
        file
        |> Path.expand(Path.dirname(path))
        |> File.read!()
        |> Jason.decode!()
      end)

    merged_namespaces =
      Enum.reduce(includes, %{}, fn ns_map, acc ->
        Map.merge(acc, ns_map)
      end)

    %{
      "version" => root["version"],
      "namespaces" => merged_namespaces
    }
  end

  defp generate_module_file(output_path, namespace, commands) do
    module_name = "SweetDate." <> classify(namespace)
    file_name = Macro.underscore(module_name) <> ".ex"
    file_path = Path.join(output_path, file_name)

    content = generate_module(module_name, namespace, commands)

    File.mkdir_p!(Path.dirname(file_path))
    File.write!(file_path, content)
    IO.puts("✔︎ Wrote wrapper #{file_path}")
  end

  defp generate_module(module_name, namespace, commands) do
    normalized_commands = normalize_commands(commands)

    methods =
      normalized_commands
      |> Enum.map(fn {command_name, command_def} ->
        params_doc = generate_params_doc(command_def)

        """
        @doc \"\"\"
        #{command_def["description"] || "TODO: Add description for #{command_name}"}

        #{params_doc}
        \"\"\"
        def #{normalize_fn_name(command_name)}(params) do
          # TODO: implement #{namespace}.#{command_name}
        end
        """
      end)

    body = Enum.join(methods, "\n") |> indent(2)

    """
    defmodule #{module_name} do
      @moduledoc \"\"\"
      #{classify(namespace)} API wrapper.

      This module provides functions for #{String.downcase(namespace)} operations.
      \"\"\"

    #{body}
    end
    """
  end

  defp normalize_commands(commands) when is_list(commands) do
    commands
    |> Enum.map(fn command ->
      {command["name"], command}
    end)
  end

  defp normalize_commands(commands) when is_map(commands) do
    commands
    |> Map.to_list()
  end

  defp normalize_commands(_commands) do
    []
  end

  defp generate_params_doc(%{"params" => params}) when params != %{} do
    param_docs =
      params
      |> Enum.map(fn {name, spec} ->
        required_text = if spec["required"], do: "(required)", else: "(optional)"
        type_text = spec["type"] || "string"
        enum_text = if spec["enum"], do: " - one of: #{inspect(spec["enum"])}", else: ""
        "  - `#{name}`: #{type_text} #{required_text}#{enum_text}"
      end)
      |> Enum.join("\n")

    "## Parameters\n\n#{param_docs}"
  end

  defp generate_params_doc(_), do: "## Parameters\n\n  No parameters required."

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
