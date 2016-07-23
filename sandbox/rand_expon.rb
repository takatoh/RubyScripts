# encoding: Windows-31J


class RandExpon
  def initialize(lamda)
    @lamda = lamda
    @r = Random.new
  end

  def rand
    -1.0 / @lamda * Math.log(1 - @r.rand)
  end
end


expon = RandExpon.new(0.5)
10000.times do |i|
  puts expon.rand
end
