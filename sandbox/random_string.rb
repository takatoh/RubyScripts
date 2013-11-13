# coding: utf-8

def randstr(length)
  pool = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
  r = Random.new
  l = pool.size
  rand_str = ''
  length.times do |i|
    rand_str += pool[r.rand(l)]
  end
  rand_str
end

length = ARGV.shift.to_i
print randstr(length)

