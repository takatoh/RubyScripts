#
# cf. http://ja.doukaku.org/23/
#
# left < right, top < bottom


class Rect
  def initialize(left, top, right, bottom)
    @left = left
    @top = top
    @right = right
    @bottom = bottom
  end

  def vertexes
    [ [@left, @top],
      [@left, @bottom],
      [@right, @bottom],
      [@right, @top] ]
  end

  def inner?(x,y)
    (@left < x && x < @right) && (@top < y && y < @bottom)
  end

  def overlap?(rect)
    rect.vertexes.any?{|x,y| inner?(x,y) }
  end
end


r1 = Rect.new(  0,   0, 100, 100)
r2 = Rect.new(100,   0, 200, 100)
r3 = Rect.new( 50,  50, 150, 100)

p r1.overlap?(r2)                   # => false
p r1.overlap?(r3)                   # => true
p r2.overlap?(r3)                   # => true

