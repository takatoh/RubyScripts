#!/usr/bin/env ruby
# encoding: utf-8


require 'random_string'

def usage
  puts "Usage: random_string.rb <length>"
end

length = ARGV.shift.to_i
if length < 1
  usage
  exit
end

puts RandomString.new(('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).randstr(length)
