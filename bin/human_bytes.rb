#! ruby
# encoding: utf-8


require 'human_bytes'

puts HumanBytes.human_bytes(ARGV.shift.to_i)
