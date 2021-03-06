#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'json'

def yaml2json(src)
  doc = YAML.load_file(src)
  JSON.pretty_generate(doc)
end

def json2yaml(src)
  doc = File.open(src){|f| JSON.parse(f.read) }
  doc.to_yaml
end

src = ARGV.shift
ext = File.extname(src).downcase
case ext
when ".yaml", ".yml"
  puts yaml2json(src)
when ".json"
  puts json2yaml(src)
else
  puts "Unsupported format."
end
