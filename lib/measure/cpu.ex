defmodule UnixStats.Measure.Cpu do
  @behaviour UnixStats.Measure.Monitor

  alias Support.CliExecutor

  def measure(_, _) do
    ~s<grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'>
    |> CliExecutor.execute()
  end
end
