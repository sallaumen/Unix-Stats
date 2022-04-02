defmodule Support.Printer do
  def print_header(:pretty), do: :noop
  def print_header(:csv), do: IO.puts("time(s),cpu,ram,gpu,graphic ram")

  def print_result({time, cpu, ram, {gpu, g_ram}}, :pretty) do
    IO.puts("Elapsed Time: #{time}    CPU: #{cpu}%    RAM: #{ram}%    GPU: #{gpu}%    Graphic RAM: #{g_ram}%")
  end

  def print_result({time, cpu, ram, {gpu, g_ram}}, :csv) do
    IO.puts("#{time};#{cpu};#{ram};#{gpu};#{g_ram}")
  end
end
