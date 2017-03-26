# encoding: utf-8


class RandomString

  def initialize(pool = ('a'..'z').to_a + ('0'..'9').to_a)
    @pool = pool
    @l = @pool.size
  end

  def randstr(length)
    r = Random.new
    random_string = ''
    length.times do |i|
      random_string += @pool[r.rand(@l)]
    end
    random_string
  end

end


if __FILE__ == $0

  def usage
    puts "Usage: random_string.rb <length>"
  end

  length = ARGV.shift.to_i
  if length < 1
    usage
    exit
  end

  puts RandomString.new(('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).randstr(length)

end
