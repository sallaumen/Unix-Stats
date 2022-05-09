defmodule UnixStats.Measure.Monitor do
  @callback measure(process_name :: String.t(), error_count :: integer()) :: measurement :: String.t()
end
