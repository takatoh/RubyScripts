# encoding: utf-8


def sum_of_kuku
  a = (1..9).to_a
  a.product(a).map{|x,y| x * y}.inject(:+)
end


puts sum_of_kuku
