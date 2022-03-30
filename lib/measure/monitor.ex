defmodule UnixStats.Measure.Monitor do
  @callback measure(process_name :: String.t()) :: measurement :: String.t()
end
