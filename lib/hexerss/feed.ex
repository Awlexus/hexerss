defmodule Hexerss.Feed do
  alias Hexerss.Hexpm
  alias Hexerss.Feed.Item

  defstruct [:title, :link, :description, :items]

  @type t :: %__MODULE__{
          title: String.t(),
          link: String.t(),
          items: [Item.t()]
        }

  @callback content_type() :: String.t()
  @callback build_feed(Feed.t()) :: iodata()

  @spec build([String.t()], ([String.t()] -> String.t())) :: {:ok, t} | {:error, :empty_feed}
  def build(package_list, link_fun) when is_function(link_fun, 1) do
    stream =
      Task.async_stream(package_list, &Hexpm.fetch_package/1, timeout: 30_000, on_timeout: :exit)

    packages = for {:ok, {:ok, package}} <- stream, do: package

    if packages == [] do
      {:error, :empty_feed}
    else
      {:ok,
       %__MODULE__{
         title: title(packages),
         link: link_fun.(Enum.map(packages, & &1.name)),
         description: description(packages),
         items: build_items(packages)
       }}
    end
  end

  def extract_package({:ok, {:ok, package}}), do: package
  def extract_package(_), do: nil

  defp build_items(packages) do
    map = Map.new(packages, &{&1.name, &1})

    items =
      for package <- packages,
          release <- package.releases do
        %{
          package: package.name,
          docs: release.docs,
          version: release.version,
          timestamp: release.inserted_at
        }
      end

    items
    |> Enum.sort_by(& &1.timestamp, :desc)
    |> Enum.take(20)
    |> Enum.map(&Item.build(map[&1.package], &1))
  end

  defp title([package]), do: "Package releases of #{package.name}"
  defp title(_packages), do: "Custom feed"

  defp description([package]), do: package.description

  defp description(packages) do
    names =
      packages
      |> Enum.map(& &1.name)
      |> Enum.sort()
      |> humanized_join()

    ["Feed for the packages: ", names]
  end

  defp humanized_join([item]), do: item
  defp humanized_join([a, b]), do: "#{a} and #{b}"

  defp humanized_join(list) do
    [head | tail] = :lists.reverse(list)

    joined =
      tail
      |> :lists.reverse()
      |> Enum.intersperse(", ")

    [joined, " and ", head]
  end
end
