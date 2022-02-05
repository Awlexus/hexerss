defmodule Hexerss.Hexpm.ApiClient do
  use Tesla

  @user_agent "Hexerss/#{Hexerss.MixProject.project()[:version]} (Elixir/#{System.version()}) (OTP/#{:erlang.system_info(:otp_release)})"

  plug Tesla.Middleware.BaseUrl, "https://hex.pm/api"

  plug Tesla.Middleware.Headers, [
    {"user-agent", @user_agent},
    {"accept", "application/vnd.hex+erlang"}
  ]

  # plug Tesla.Middleware.Logger

  def package_info(package) do
    case get("/packages/#{package}") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, :erlang.binary_to_term(body)}
      {:ok, %Tesla.Env{status: 304}} -> {:ok, :unchanged}
      {:ok, other} -> {:error, other}
      {:error, error} -> {:error, error}
    end
  end
end
