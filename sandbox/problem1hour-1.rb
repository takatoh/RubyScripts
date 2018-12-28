def solv1(ary)
  result = 0
  for i in ary
    result += i
  end
  result
end

def solv2(ary)
  result = 0
  while ary.size > 0
    result += ary.shift
  end
  result
end

def solv3(ary)
  if ary.empty?
    0
  else
    x = ary.shift
    x + solv3(ary)
  end
end

puts solv1([1,2,3,4,5])
puts solv2([1,2,3,4,5])
puts solv3([1,2,3,4,5])
