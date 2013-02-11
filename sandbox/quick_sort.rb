def quick_sort(ary)
  return [] if ary.empty?
  p = ary.shift
  left = ary.select{|x| x < p }
  right = ary.select{|x| x >= p}
  return quick_sort(left) + [p] + quick_sort(right)
end


a = (1..9).to_a * 2
a.shuffle!
print "unsorted: "
p a

a2 = quick_sort(a)
print "sorted:   "
p a2


  