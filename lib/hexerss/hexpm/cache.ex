defmodule Hexerss.Hexpm.Cache do
  def child_spec(opts) do
    config = Application.get_env(:hexerss, __MODULE__)

    opts =
      opts
      |> Keyword.put_new(:name, __MODULE__)
      |> Keyword.put_new(:global_ttl, config[:global_ttl])
      |> Keyword.put_new(:ttl_check_interval, config[:ttl_check_interval])

    Supervisor.child_spec({ConCache, opts}, id: __MODULE__)
  end
end
