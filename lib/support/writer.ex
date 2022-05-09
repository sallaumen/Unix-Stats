defmodule Support.Writer do
  alias Support.Formatter

  def write_result_to_file(metrics, file_name) do
    metrics
    |> Formatter.format_numbers()
    |> write_to_file(file_name)
  end

  defp write_to_file([time, cpu, ram, gpu, g_ram], file_name) do
    File.write("measurements/#{file_name}", "\n#{time};#{cpu};#{ram};#{gpu};#{g_ram}", [:append])
  end
end
