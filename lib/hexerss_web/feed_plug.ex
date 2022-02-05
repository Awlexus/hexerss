defmodule HexerssWeb.FeedPlug do
  use Plug.Builder

  alias Hexerss.Feed

  plug :fetch_query_params
  plug :assign_type
  plug :fetch_packages
  plug :send_feed

  defp assign_type(conn, _) do
    {type, builder} =
      case conn.params["type"] do
        "atom" -> {:atom, Feed.Atom}
        _ -> {:rss, Feed.Rss2}
      end

    conn
    |> assign(:type, type)
    |> assign(:builder, builder)
  end

  defp fetch_packages(conn, _) do
    case conn.params["packages"] do
      nil ->
        conn
        |> send_resp(400, "Missing package list")
        |> halt()

      "" ->
        empty_feed(conn)

      packages ->
        package_list = String.split(packages, ",", trim: true)

        case Feed.build(package_list, build_link(conn)) do
          {:ok, feed} -> assign(conn, :feed, feed)
          {:error, :empty_feed} -> empty_feed(conn)
        end
    end
  end

  defp send_feed(conn, _) do
    %{builder: builder, feed: feed} = conn.assigns

    conn
    |> put_resp_header("content-type", builder.content_type)
    |> send_resp(200, builder.build_feed(feed))
  end

  defp empty_feed(conn) do
    conn
    |> put_resp_header("content-type", "text/plain;charset=UTF-8")
    |> send_resp(400, "Empty Feed. No packages were given or none of the packages exist")
  end

  defp build_link(conn) do
    port =
      case conn.port do
        80 -> ""
        other -> ":#{other}"
      end

    type = conn.assigns.type
    url = "#{conn.scheme}://#{conn.host}#{port}/feed?type=#{type}&amp;packages="

    fn package_list ->
      url <> Enum.join(package_list, ",")
    end
  end
end
