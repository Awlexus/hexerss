defmodule Hexerss.Hexpm.Cache do
  def child_spec(opts) do
    config = Application.get_env(:hexerss, __MODULE__)

    opts = Keyword.put_new(opts, :name, __MODULE__)
    opts = Keyword.put_new(opts, :global_ttl, config[:global_ttl])
    opts = Keyword.put_new(opts, :ttl_check_interval, config[:ttl_check_interval])

    Supervisor.child_spec({ConCache, opts}, id: __MODULE__)
  end
end
