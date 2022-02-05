import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :hexerss, Hexerss.Hexpm.Cache,
  ttl_check_interval: :timer.minutes(5),
  global_ttl: :timer.minutes(30)
