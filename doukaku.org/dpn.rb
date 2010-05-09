# cf. http://ja.doukaku.org/25/


def divisors(n)
  (1..(n/2+1)).to_a.select{|x| n % x == 0 }
end

def double_complete_number?(n)
  divisors(n).inject(0){|a,b| a+b } == 2 * n
end

(1..1000).to_a.each do |n|
  puts n if double_complete_number?(n)
end

