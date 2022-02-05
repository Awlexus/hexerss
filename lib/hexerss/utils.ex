defmodule Hexerss.Utils do
  def unix_to_http(timestamp) do
    timestamp
    |> DateTime.from_unix!()
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S %z")
  end

  def unix_to_iso8601(timestamp) do
    timestamp
    |> DateTime.from_unix!()
    |> DateTime.to_iso8601()
  end
end
