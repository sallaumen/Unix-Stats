defmodule UnixStats.Measure.Ram do
  @behaviour UnixStats.Measure.Monitor

  alias Support.CliExecutor

  def measure(_) do
    ~s<free | grep Mem | awk '{usage=($3/$2)*100} END {print usage}'>
    |> CliExecutor.execute()
  end
end
