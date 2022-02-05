defmodule Hexerss.Feed.Rss2 do
  @behaviour Hexerss.Feed
  alias Hexerss.{Feed, Utils}
  alias Hexerss.Feed.Item

  @impl true
  def content_type(), do: "application/rss+xml"

  @impl true
  def build_feed(%Feed{} = feed) do
    [
      ~s(<?xml version="1.0" encoding="UTF-8" ?><rss version="2.0"><channel><title>),
      feed.title,
      "</title><link>",
      feed.link,
      "</link><description>",
      feed.description,
      "</description><ttl>30</ttl>",
      build_items(feed.items),
      "</channel></rss>"
    ]
  end

  defp build_items(items) do
    Enum.map(items, fn %Item{} = item ->
      [
        "<item><title>",
        item.name,
        "</title><link>",
        item.link,
        "</link><description>",
        item.description,
        ~s(</description><guid>https://hex.pm/packages/),
        item.name,
        "/",
        item.version,
        "</guid><pubDate>",
        Utils.unix_to_http(item.timestamp),
        ~s(</pubDate><source url="https://hex.pm">Hex - The package manager for the Erlang ecosystem</source></item>)
      ]
    end)
  end
end
