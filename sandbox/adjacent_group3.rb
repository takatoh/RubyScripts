def adjacent_group(ary)
  ary.inject([]) do |a, x|
    if !a.empty? && x == a[-1][-1]
      a[-1] << x
    else
      a << [x]
    end
    a
  end
end

p adjacent_group([1, 1, 2, 2, 3, 1, 1])
p adjacent_group([])
