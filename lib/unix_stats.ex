defmodule UnixStats do
  require Logger

  alias UnixStats.Measure.{
    Cpu,
    Gpu,
    Ram
  }

  def measure(time, format, process), do: measure_and_inspect(time, format, process)
  def measure(time, format), do: measure(time, format, "beam.smp")

  def measure() do
    time = 60
    format = :pretty
    process = "beam.smp"
    Logger.info("Using default settings: #{time} seconds, #{format} view and \"#{process}\" process")
    measure(time, format, process)
  end

  defp measure_and_inspect(time, format, process) do
    period = 0..time

    print_header(format)

    Enum.map(period, fn second ->
      second
      |> measure_all(process)
      |> print_result(format)

      :timer.sleep(1000)
    end)

    :ok
  end

  defp measure_all(second, process) do
    {
      second,
      Cpu.measure(process),
      Ram.measure(process),
      Gpu.measure(process)
    }
  end

  defp print_header(:pretty), do: :noop
  defp print_header(:csv), do: IO.puts("time(s),cpu,ram,gpu,graphic ram")

  defp print_result({time, cpu, ram, {gpu, g_ram}}, :pretty) do
    IO.puts("Elapsed Time: #{time}    CPU: #{cpu}%    RAM: #{ram}%    GPU: #{gpu}%    Graphic RAM: #{g_ram}%")
  end

  defp print_result({time, cpu, ram, {gpu, g_ram}}, :csv) do
    IO.puts("#{time};#{cpu};#{ram};#{gpu};#{g_ram}")
  end
end
