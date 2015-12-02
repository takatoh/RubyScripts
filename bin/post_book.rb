#!/usr/bin/env ruby
# encoding: utf-8


require 'httpclient'
require 'yaml'
require 'csv'
require 'json'
require 'optparse'


def post_book(book)
  post_url = "http://localhost:5000/api/book/add/"
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
  json_data = post_data.to_json

  res = @client.post_content(post_url, json_data, "Content-Type" => "application/json")
  result = JSON.parse(res)
  puts title_with_vol(result["books"].first)
end

def title_with_vol(book)
  if book["volume"].nil? || book["volume"].empty?
    book["title"]
  else
    book["title"] + " [" + book["volume"] + "]"
  end
end


options = {}
opts = OptionParser.new
opts.banner = <<EOB
Usage: #{opts.program_name} [options] <inputfile.yaml>

Options:
EOB
opts.on("--csv", "Input from CSV."){|v| options[:csv] = true }
opts.on_tail("--help", "-h", "Show this message"){|v|
  puts opts.help
  exit(0)
}
opts.parse!

@client = HTTPClient.new

inputfile = ARGV.shift
books = if options[:csv]
  csvfile = File.open(inputfile, "r")
  CSV.new(csvfile, headers: true)
else
  YAML.load_file(inputfile)["books"]
end
books.each do |book|
#  puts title_with_vol(row)
  post_book(book)
end
