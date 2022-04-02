defmodule UnixStats do
  require Logger

  alias Support.Printer
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
    period = 0..time*10

    Printer.print_header(format)

    Enum.map(period, fn iteration ->
      t_start = DateTime.utc_now()

      iteration
      |> measure_all(process)
      |> Printer.print_result(format)

      t_finish = DateTime.utc_now()

      sleep_100_ms(t_start, t_finish)
    end)
    :ok
  end

  defp measure_all(second, process) do
    {
      second/10,
      Cpu.measure(process),
      Ram.measure(process),
      Gpu.measure(process)
    }
  end

  defp sleep_100_ms(t_start, t_finish) do
    exec_time = DateTime.diff(t_start, t_finish, :millisecond)
    :timer.sleep(100 + exec_time)
  end
end
