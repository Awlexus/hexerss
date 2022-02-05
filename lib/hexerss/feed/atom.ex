defmodule Hexerss.Feed.Atom do
  @behaviour Hexerss.Feed

  alias Hexerss.{Feed, Utils}
  alias Hexerss.Feed.Item

  def content_type() do
    "application/atom+xml"
  end

  def build_feed(%Feed{} = feed) do
    updated_at =
      feed.items
      |> List.first()
      |> Map.get(:timestamp)
      |> Utils.unix_to_iso8601()

    [
      ~s(<?xml version="1.0" encoding="UTF-8" ?><feed xmlns="http://www.w3.org/2005/Atom"><title>),
      feed.title,
      ~s(
      </title><link href="),
      feed.link,
      ~s("/><updated>),
      updated_at,
      ~s(</updated><id>),
      feed.link,
      ~s(</id>),
      build_entries(feed.items),
      ~s(</feed>)
    ]
  end

  defp build_entries(items) do
    Enum.map(items, fn %Item{} = item ->
      [
        ~s(<entry>),
        build_authors(item.authors),
        ~s(<title>),
        item.name,
        ~s(</title><link href="),
        item.link,
        ~s("/><id>https://hex.pm/packages/),
        item.name,
        "/",
        item.version,
        ~s(</id><updated>),
        Utils.unix_to_iso8601(item.timestamp),
        ~s(</updated><summary>),
        item.description,
        ~s(</summary></entry>)
      ]
    end)
  end

  defp build_authors(authors), do: Enum.map(authors, &["<author><name>", &1, "</name></author>"])
end
