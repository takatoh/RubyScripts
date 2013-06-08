#
# AIZU ONLINE JUDGE: Smart Calculator
# cf. http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0109&lang=jp
#


class Fixnum
  def / (x)
    y = self.to_f.fdiv(x)
    if y < 0.0
      y = y.ceil
    else
      y = y.floor
    end
    y
  end
end


while n = gets do
  n.to_i.times do
    puts eval(gets.chomp.chop)
  end
end

