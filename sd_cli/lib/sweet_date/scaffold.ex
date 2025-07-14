defmodule SweetDate.Scaffold do
  def run(language) do
    case String.downcase(language) do
      "ruby" -> SweetDate.Scaffold.RubyWrapper.run()
      _ -> raise "Unsupported language: #{language}"
    end
  end
end
