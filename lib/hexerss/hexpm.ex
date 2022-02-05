defmodule Hexerss.Hexpm do
  use Supervisor
  alias Hexerss.Hexpm.{ApiClient, Cache, Package}

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  def init(_) do
    children = [Cache]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec fetch_package(String.t(), keyword()) :: {:ok, Package.t()} | {:error, term}
  def fetch_package(package, opts \\ []) do
    cache = Keyword.get(opts, :cache, Cache)

    ConCache.fetch_or_store(cache, {:package, package}, fn ->
      with {:ok, response} <- ApiClient.package_info(package) do
        {:ok, Package.parse(response)}
      end
    end)
  end
end
