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
      name: "#{package.name} v#{release.version}",
      link: build_link(package, release),
      description: package.description,
      version: release.version,
      timestamp: release.timestamp,
      authors: package.authors
    }
  end

  defp build_link(package, release) do
    case Enum.at(package.releases, release.local_index + 1) do
      nil -> "https://hex.pm/packages/#{package.name}"
      prev -> "https://diff.hex.pm/diff/#{package.name}/#{prev.version}..#{release.version}"
    end
  end
end
