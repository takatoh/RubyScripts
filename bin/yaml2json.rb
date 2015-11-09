#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'json'

yaml = ARGV.shift
doc = YAML.load_file(yaml)
puts JSON.pretty_generate(doc)
