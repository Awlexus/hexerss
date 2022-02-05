defmodule Hexerss.Hexpm.Package.Release do
  defstruct [:docs, :inserted_at, :url, :version]

  @type unix_timestamp :: non_neg_integer()

  @type t :: %__MODULE__{
          docs: boolean(),
          inserted_at: unix_timestamp(),
          version: String.t()
        }

  @spec parse(map()) :: t()
  def parse(body) do
    %__MODULE__{
      docs: body["has_docs"],
      inserted_at: to_unix(body["inserted_at"]),
      url: body["url"],
      version: body["version"]
    }
  end

  defp to_unix(timestamp) do
    with _ when is_binary(timestamp) <- timestamp,
         {:ok, dt, _} <- DateTime.from_iso8601(timestamp) do
      DateTime.to_unix(dt)
    else
      _ -> nil
    end
  end
end
