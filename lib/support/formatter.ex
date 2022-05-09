defmodule Support.Formatter do
  def format_numbers({time, cpu, ram, {gpu, g_ram}}) do
    metrics = [time, cpu, ram, gpu, g_ram]
    Enum.map(metrics, fn metric -> change_decimal_place_marker(metric) end)
  end

  defp change_decimal_place_marker(number) do
    case is_binary(number) do
      true -> String.replace(number, ".", ",")
      false -> number |> Float.to_string() |> String.replace(".", ",")
    end
  end
end
