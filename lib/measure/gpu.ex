defmodule UnixStats.Measure.Gpu do
  @behaviour UnixStats.Measure.Monitor

  alias Support.CliExecutor

  @gpu_ram_limit 7981

  def measure(_, error_count) when error_count >= 30, do: {"0.0", "0.0"}
  def measure(process, _error_count) do
    data =
      "nvidia-smi"
      |> CliExecutor.execute()
      |> split_when_possible()

    {
      get_gpu_use_from_data(data),
      get_video_memory_use_from_data(data, process)
    }
  end

  defp split_when_possible(output) do
    case String.contains?(output, "not found") do
      true -> :not_found
      false -> String.split(output, "\n")
    end
  end

  defp get_gpu_use_from_data(:not_found), do: "0"

  defp get_gpu_use_from_data(data) do
    data
    |> Enum.at(9)
    |> String.split("|")
    |> Enum.at(3)
    |> String.replace("Default", "")
    |> String.replace("%", "")
    |> String.trim()
  end

  defp get_video_memory_use_from_data(:not_found, _), do: "0"

  defp get_video_memory_use_from_data(data, process) do
    beam_use =
      data
      |> Enum.filter(fn line -> String.contains?(line, process) end)

    case beam_use do
      [] ->
        "0"

      _ ->
        beam_use
        |> Enum.at(0)
        |> get_process_memory_use(process)
    end
  end

  defp get_process_memory_use(process_line, process_name) do
    string_amount =
      process_line
      |> String.split(process_name)
      |> Enum.filter(fn line -> String.contains?(line, " |") end)
      |> Enum.at(0)
      |> String.replace("|", "")
      |> String.trim()

    size = String.length(string_amount)

    amount =
      string_amount
      |> String.slice(0, size - 3)
      |> String.to_integer()

    (amount * 100 / @gpu_ram_limit)
    |> Float.round(4)
  end
end
