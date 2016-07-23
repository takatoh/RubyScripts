#!/usr/bin/env ruby
# coding: utf-8


class StrRand

  def initialize(pool)
    @pool = pool
    @l = @pool.size
  end

  def strrand(length)
    r = Random.new
    random_string = ''
    length.times do |i|
      random_string += @pool[r.rand(@l)]
    end
    random_string
  end

end


def usage
  puts "Usage: random_string.rb <length>"
end

length = ARGV.shift.to_i
usage if length < 1

puts StrRand.new(('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).strrand(length)

