defmodule Clp.Config do
  @moduledoc false

  @config_file "clp.config.json"

  def load do
    with {:ok, raw} <- File.read(@config_file),
         {:ok, config} <- Jason.decode(raw) do
      {:ok, config}
    else
      {:error, reason} -> {:error, {:config_load_failed, reason}}
    end
  end

  def resolve_paths(lang) do
    with {:ok, config} <- load(),
         %{"protocol" => protocol, "targets" => targets} <- config,
         %{"output" => output_path} <- Map.get(targets, lang) do
      {:ok,
       %{
         protocol_path: Path.expand(protocol),
         output_path: Path.expand(output_path),
         language: lang
       }}
    else
      _ -> {:error, :invalid_or_missing_config}
    end
  end
end
