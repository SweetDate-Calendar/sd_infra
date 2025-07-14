defmodule SweetDate.Protocol do
  alias ExJsonSchema.Schema
  alias ExJsonSchema.Validator

  @schema_path Path.expand("protocol/calendar_protocol.schema.json", __DIR__)

  def load(file_path) do
    with {:ok, schema_json} <- File.read(@schema_path),
         {:ok, protocol_json} <- File.read(file_path),
         {:ok, schema} <- Jason.decode(schema_json),
         {:ok, protocol} <- Jason.decode(protocol_json) do
      schema = Schema.resolve(schema)

      case Validator.validate(schema, protocol) do
        :ok -> {:ok, protocol}
        {:error, errors} -> {:error, format_errors(errors)}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp format_errors(errors) do
    Enum.map(errors, fn {path, message} -> "#{path}: #{message}" end)
  end
end
