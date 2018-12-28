def combi(ary)
  if ary.size == 1
    ary
  else
    result = []
    x = ary.shift
    c = combi(ary)
    ["+", "-", ""].each do |op|
      result += c.map{|e| x + op + e }
    end
    result
  end
end

def solv
  a = [1,2,3,4,5,6,7,8,9].map{|n| n.to_s }
  result = []
  combi(a).each do |e|
    if eval(e) == 100
      result << e
    end
  end
  result
end

solv.each do |e|
  puts e + " = 100"
end
