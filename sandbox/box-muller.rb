# encoding: Windows-31J


class BoxMuller
  def initialize(mu, sigma)
    @mu = mu
    @sigma = sigma
    @r = Random.new
    @z2 = nil
  end

  def rand
    if @z2
      z1 = @z2
      @z2 = nil
    else
      x = @r.rand
      y = @r.rand
      z1 = Math.sqrt(-2.0 * Math.log(x)) * Math.sin(2 * Math::PI * y)
      @z2 = Math.sqrt(-2.0 * Math.log(x)) * Math.cos(2 * Math::PI * y)
    end
    @sigma * z1 + @mu
  end
end


bm = BoxMuller.new(1.0, 0.2)
10000.times do |i|
  puts bm.rand
end
