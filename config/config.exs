import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :hexerss, Hexerss.Hexpm.Cache,
  ttl_check_interval: :timer.minutes(5),
  global_ttl: :timer.minutes(30)

config :exsync, addition_dirs: ~w"/priv", extensions: ~w".ex .html"
