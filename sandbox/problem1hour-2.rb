def solv(a1, a2)
  result = []
  until a1.empty?
    result << a1.shift
    result << a2.shift
  end
  result
end

p solv(['a', 'b', 'c'], [1, 2, 3])
