#!ruby
# encoding: utf-8
#
# Look up information of book by ISBN with Amazon.
#
#
# Rubygem `amazon-ecs' and `lisbn' are required.
# You can install the gems:
#
# <tt>gem install amazon-ecs</tt>
# <tt>gem install lisbn</tt>
#

require 'amazon/ecs'
require 'lisbn'
require 'yaml'
require 'optparse'


SCRIPT_VERSION = "v0.2.0"

@config = YAML.load_file(File.join(ENV["HOME"], "aws-config.yaml"))
Amazon::Ecs.options = {
  :associate_tag     => @config["ASSOCIATE_TAG"],
  :AWS_access_key_id => @config["ACCESS_KEY_ID"],
  :AWS_secret_key    => @config["SECRET_ACCESS_KEY"]
}

def search(code)
  asin = Lisbn.new(code).isbn10
  res = Amazon::Ecs.item_lookup(
    asin,
    :response_group => "ItemAttributes",
    :country => "jp")
  element = res.items.first.get_element("ItemAttributes")
  { 'title'        => element.get('Title'),
    'author'       => element.get('Author'),
    'publisher'    => element.get('Publisher'),
    'manufacturer' => element.get('Manufacturer'),
    'isbn'         => element.get('ISBN') }
end

options = {}
opt = OptionParser.new
opt.banner = <<EOB
Usage: #{opt.program_name} [options] ISBN
EOB
opt.on('-i', '--input=FILE', 'read ISBN from FILE.'){|f| options[:inputfile] = f}
opt.on_tail('-h', '--help', 'show this message'){|v| print opt; exit}
opt.on_tail('-v', '--version', 'show version'){|v| puts SCRIPT_VERSION; exit}
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
