defmodule Support.CliExecutor do
  def execute(command) do
    command
    |> String.to_charlist()
    |> :os.cmd()
    |> List.to_string()
    |> clean_response_from_os_response_jump_line()
  end

  defp clean_response_from_os_response_jump_line(data) do
    String.trim_trailing(data, "\r\n")
    String.trim_trailing(data, "\n")
  end
end
