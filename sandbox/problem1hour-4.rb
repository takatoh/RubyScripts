def solv(ary)
  ary.map{|x| x.to_s }.sort.reverse.join("").to_i
end

puts solv([50, 2, 1, 9])
