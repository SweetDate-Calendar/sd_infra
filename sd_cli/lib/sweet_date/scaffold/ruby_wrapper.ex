defmodule SweetDate.Scaffold.RubyWrapper do
  alias SweetDate.Config

  def run do
    with {:ok, paths} <- Config.resolve_paths("ruby"),
         protocol <- load_protocol(paths.protocol_path) do
      # namespaces = Map.get(protocol, "namespaces", %{})

      protocol["namespaces"]
      |> Enum.each(fn {namespace, defn} ->
        generate_wrapper_file(paths.output_path, namespace, defn["commands"])
      end)
    end
  end

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

  defp generate_wrapper_file(output_path, namespace, commands) do
    module_name = classify(namespace)
    file_name = String.downcase(module_name) <> ".rb"
    dir_path = Path.join(output_path, "sweet_date")
    file_path = Path.join(dir_path, file_name)
    content = generate_class(module_name, namespace, commands)
    File.mkdir_p!(dir_path)
    File.write!(file_path, content)
    IO.puts("\u2713 Wrote wrapper #{file_path}")
  end

  # defp generate_class(class_name, namespace, commands) do
  #   methods =
  #     commands
  #     |> normalize_commands()
  #     |> Enum.map(fn {command_name, _command_def} ->
  #       method_name = normalize_method_name(command_name)

  #       """
  #       def self.#{method_name}(params)
  #         # TODO: implement #{namespace}.#{command_name}
  #       end
  #       """
  #     end)

  #   body = Enum.join(methods, "\n") |> indent(4)

  #   """
  #   module SweetDate
  #   class #{class_name}
  #   #{body}
  #     end
  #   end
  #   """
  # end
  defp generate_class(class_name, namespace, commands) do
    methods =
      commands
      |> normalize_commands()
      |> Enum.map(fn {command_name, command_def} ->
        method_name = normalize_method_name(command_name)
        doc = format_doc(command_def)

        """
        #{doc}
        def self.#{method_name}(params)
          # TODO: implement #{namespace}.#{command_name}
        end
        """
      end)

    body = Enum.join(methods, "\n") |> indent(4)

    """
    module SweetDate
    class #{class_name}
    #{body}
      end
    end
    """
  end

  defp format_doc(command) do
    description = command["description"] || "No description provided."

    params_doc =
      case command["params"] do
        nil ->
          nil

        params ->
          "# params:\n" <>
            Enum.map_join(params, "\n", fn {key, spec} ->
              required = if spec["required"], do: "required", else: "optional"
              type = spec["type"]
              "#   - #{key}: #{type} (#{required})"
            end)
      end

    example =
      case command["response"]["example"] do
        nil -> nil
        ex -> "# return example:\n# " <> encode_json_comment(ex)
      end

    error_example =
      case command["response"]["error_example"] do
        nil -> nil
        ex -> "# error example:\n# " <> encode_json_comment(ex)
      end

    ["# #{description}", params_doc, example, error_example]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
  end

  defp encode_json_comment(data) do
    data
    |> Jason.encode!()
    |> String.replace("\n", "")
    # Prevent nested formatting
    |> String.replace(~r/(.)/, "\\1")
  end

  # Handle both old format (map) and new format (array)
  defp normalize_commands(commands) when is_list(commands) do
    # New array format - preserve order
    commands
    |> Enum.map(fn command ->
      {command["name"], command}
    end)
  end

  defp normalize_commands(commands) when is_map(commands) do
    # Old map format - convert to list (order not preserved)
    commands
    |> Map.to_list()
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
