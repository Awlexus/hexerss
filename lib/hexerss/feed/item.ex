defmodule Hexerss.Feed.Item do
  defstruct [:name, :link, :description, :version, :timestamp, :authors]

  @type t :: %__MODULE__{
          name: String.t(),
          link: String.t(),
          description: String.t(),
          version: String.t(),
          timestamp: String.t(),
          authors: [String.t()]
        }

  def build(package, release) do
    %__MODULE__{
      name: package.name,
      link: "https://hex.pm/packages/#{package.name}",
      description: package.description,
      version: release.version,
      timestamp: release.timestamp,
      authors: package.authors
    }
  end
end
