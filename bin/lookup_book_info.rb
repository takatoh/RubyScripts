#!ruby
# encoding: utf-8
#
# Look up information of book by ISBN with Amazon.
#
#
# Rubygem `ruby-aaws' is required.
# You can install the gem:
#
# <tt>gem install ruby-aaws</tt>
#

require 'amazon/aws/search'
require 'optparse'


def search(code)
  a = Amazon::AWS::ItemSearch.new("Books", {"Keywords" => code})
  a.response_group = Amazon::AWS::ResponseGroup.new(:Medium)
  req = Amazon::AWS::Search::Request.new
  begin
    res = req.search(a)
    get_property(res.item_search_response.items.item)
  rescue
    Hash.new
  end
end

def get_property(item)
  asin = item.asin.to_s
  attr = item.item_attributes.to_h
  attr.each_key do |key|
    attr[key] = attr[key].to_s
  end
  attr["asin"] ||= asin
  attr
end


options = {}
opt = OptionParser.new
opt.on('-i', '--input=FILE', 'read ISBN from FILE.'){|f| options[:inputfile] = f}
opt.parse!

codes = if options[:inputfile]
  File.open(options[:inputfile], "r"){|f| f.readlines}.map{|l| l.chomp}
else
  ARGV
end

codes.each do |code|
  item = search(code)
  puts "Title:             #{item['title']}"
  puts "Author:            #{item['author']}"
  puts "Publisher:         #{item['publisher']}"
  puts "Manufacturer:      #{item['manufacturer']}"
  puts "ISBN:              #{item['isbn']}"
  puts ""
end
