defmodule Hexerss.Application do
  use Application

  def start(_, _) do
    children = [
      Hexerss.Hexpm,
      {Plug.Cowboy, scheme: :http, plug: HexerssWeb.Router, options: [port: 4000]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
