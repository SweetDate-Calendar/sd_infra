defmodule Clp.Scaffold do
  def run(language) do
    case String.downcase(language) do
      "ruby" -> Clp.Scaffold.Ruby.run()
      _ -> raise "Unsupported language: #{language}"
    end
  end
end
