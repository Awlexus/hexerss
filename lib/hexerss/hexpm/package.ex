defmodule Hexerss.Hexpm.Package do
  alias Hexerss.Hexpm.Package.Release

  defstruct [
    :name,
    :description,
    :repository,
    :docs,
    :releases,
    :authors
  ]

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t(),
          repository: Stirng.t(),
          docs: String.t(),
          releases: [Release.t()],
          authors: [String.t()]
        }

  def parse(response) do
    %__MODULE__{
      name: response["name"],
      description: response["meta"]["description"],
      repository: repository(response),
      docs: response["docs_html_url"],
      releases: Enum.map(response["releases"], &Release.parse/1),
      authors: Enum.map(response["owners"], & &1["username"])
    }
  end

  defp repository(response) do
    links =
      response
      |> get_in(~w"meta links")
      |> Map.new(fn {k, v} -> {String.downcase(k), v} end)

    Enum.find_value(~w"github gitlab", &links[&1])
  end
end
