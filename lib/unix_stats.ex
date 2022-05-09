defmodule UnixStats do
  require Logger

  alias Support.Printer
  alias Support.Writer

  alias UnixStats.Measure.{
    Cpu,
    Gpu,
    Ram
  }

  @spec measure(time :: integer(), format :: atom(), process :: String.t()) :: :ok
  def measure(time, format, process), do: measure_and_inspect(time, format, process)

  @spec measure(time :: integer(), format :: atom()) :: :ok
  def measure(time, format), do: measure(time, format, "beam.smp")

  @spec measure() :: :ok
  def measure() do
    time = 60
    format = :pretty
    process = "beam.smp"
    Logger.info("Using default settings: #{time} seconds, #{format} view and \"#{process}\" process")
    measure(time, format, process)
  end

  defp measure_and_inspect(time, format, process_name) do
    period = 0..(time * 10)

    log_file_name = generate_log_file_name(process_name)
    Printer.print_header(format)

    Enum.map(period, fn iteration ->
      t_start = DateTime.utc_now()

      iteration
      |> measure_all(process_name)
      |> Printer.print_result(format)
      |> Writer.write_result_to_file(log_file_name)

      t_finish = DateTime.utc_now()

      sleep_100_ms(t_start, t_finish)
    end)

    :ok
  end

  defp measure_all(second, process) do
    {
      second / 10,
      Cpu.measure(process),
      Ram.measure(process),
      Gpu.measure(process)
    }
  end

  defp sleep_100_ms(t_start, t_finish) do
    exec_time = DateTime.diff(t_start, t_finish, :millisecond)
    sleep_time = 100 + exec_time

    case sleep_time > 0 do
      true -> :timer.sleep(sleep_time)
      false -> IO.puts("Taking too long to create measurements")
    end
  end

  defp generate_log_file_name(process_name) do
    {:ok, dt} = DateTime.now("Etc/UTC")
    y = with_2_decimal_places(dt.year)
    mm = with_2_decimal_places(dt.month)
    d = with_2_decimal_places(dt.day)
    h = with_2_decimal_places(dt.hour)
    m = with_2_decimal_places(dt.minute)
    s = with_2_decimal_places(dt.second)

    process_name = String.replace(process_name, ".", "_")
    "#{process_name}_#{y}#{mm}#{d}_#{h}#{m}#{s}.txt"
  end

  defp with_2_decimal_places(number) do
    number
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
