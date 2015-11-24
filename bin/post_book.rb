#!/usr/bin/env ruby
# encoding: utf-8


require 'httpclient'
require 'json'
require 'pp'


post_url = "http://localhost:5000/api/book/add/"
post_data = {
  "title"          => "夏のロケット",
  "volume"         => "",
  "series"         => "",
  "series_volume"  => "",
  "author"         => "川端裕人",
  "translator"     => "",
  "publisher"      => "",
  "category"       => "小説",
  "format"         => "文庫",
  "isbn"           => "",
  "published_on"   => "",
  "original_title" => "",
  "note"           => "",
  "keyword"        => "",
  "disk"           => "",
  "disposed"       => "0"
}

client = HTTPClient.new
res = client.post(post_url, post_data)
result = JSON.parse(res.body)
pp result
