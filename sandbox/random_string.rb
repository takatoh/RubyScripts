#!/usr/bin/env ruby
# coding: utf-8

def strrand(length)
  pool = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
  r = Random.new
  l = pool.size
  rand_str = ''
  length.times do |i|
    rand_str += pool[r.rand(l)]
  end
  rand_str
end

def usage
  puts "Usage: random_string.rb <length>"
end

length = ARGV.shift.to_i
usage if length < 1
puts strrand(length)

