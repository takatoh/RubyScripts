#!/usr/bin/env ruby
# encoding: utf-8


require 'csv'
require 'yaml'


csvfile = ARGV.shift
f = open(csvfile, 'r')
csvdata = CSV.new(f, headers: true)

data = []
csvdata.each do |row|
  x = {}
  row.each{|k, v| x[k] = v }
  data << x
end

print data.to_yaml
