#!/usr/bin/env ruby
# encoding: utf-8


require 'httpclient'
require 'csv'
require 'json'
require 'pp'


def post_book(book)
  post_url = "http://localhost:9090/api/book/add/"
  post_data = {
    "title"          => book["title"],
    "volume"         => book["volume"]         || "",
    "series"         => book["series"]         || "",
    "series_volume"  => book["series_volume"]  || "",
    "author"         => book["author"]         || "",
    "translator"     => book["translator"]     || "",
    "publisher"      => book["publisher"]      || "",
    "category"       => book["category"]       || "その他",
    "format"         => book["format"]         || "その他",
    "isbn"           => book["isbn"]           || "",
    "published_on"   => book["published_on"]   || "",
    "original_title" => book["original_title"] || "",
    "note"           => book["note"]           || "",
    "keyword"        => book["keyword"]        || "",
    "disk"           => book["disk"]           || "",
    "disposed"       => book["disposed"]       || "0"
  }

  res = @client.post(post_url, post_data)
  result = JSON.parse(res.body)
  puts title_with_vol(result["books"].first)
end

def title_with_vol(book)
  if book["volume"].nil? || book["volume"].empty?
    book["title"]
  else
    book["title"] + " [" + book["volume"] + "]"
  end
end


@client = HTTPClient.new

csvfile = File.open(ARGV.shift, "r")
csv = CSV.new(csvfile, headers: true)
csv.each do |row|
#  puts title_with_vol(row)
  post_book(row)
end
