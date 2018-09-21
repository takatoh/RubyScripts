def adjacent_group(ary)
  result = []
  current = nil
  ary.each do |x|
    if current.nil?
      current = x
      result << [x]
    elsif x == current
      result[-1] << x
    else
      current = x
      result << [x]
    end
  end
  result
end

p adjacent_group([1, 1, 2, 2, 3, 1, 1])
