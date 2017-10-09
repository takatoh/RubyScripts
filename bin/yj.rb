#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'json'

def yaml2json(src)
  doc = YAML.load_file(src)
  JSON.pretty_generate(doc)
end

def json2yaml(src)
  doc = nil
  File.open(src) do |f|
    doc = JSON.parse(f.read)
  end
  doc.to_yaml
end

src = ARGV.shift
ext = File.extname(src).downcase
if ext == ".yaml" || ext == ".yml"
  puts yaml2json(src)
elsif ext == ".json"
  puts json2yaml(src)
else
  puts "Unsupported format."
end
