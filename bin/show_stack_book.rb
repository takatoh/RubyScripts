#! ruby
# encoding: utf-8
#
#  Show information from stack.nayutaya.jp
#

require 'json'

require 'open-uri'
require 'optparse'
require 'pp'



URL_BASE = "http://stack.nayutaya.jp/api/user"

def build_url(user, state)
  "#{URL_BASE}/name/#{user}/stocks/#{state}.json?include_books=true"
end


@options = { :state => "unread" }
opts = OptionParser.new
opts.on('-u', '--user=NAME', 'User name.'){|v| @options[:username] = v}
opts.on('-s', '--state=STATE', 'specify book state - read/reading/unread/wish/stacked'){|v|
  @options[:state] = v
}
opts.on('--dump', 'dump data.'){@options[:dump] = true}
opts.parse!

unless @options[:username]
  print opts
  exit
end

url = build_url(@options[:username], @options[:state])
data = open(url){|f| JSON.load(f)}

if @options[:dump]
  pp data
  exit
end

puts "user: #{data["response"]["user"]["name"]}"
stocks = data["response"]["stocks"]
puts "stocks: #{stocks.size}"
stocks.each do |stock|
  book = stock["book"]
  puts book["title"].encode(Encoding.default_external, :replace => "_")
end

