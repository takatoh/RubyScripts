# cf. http://ja.doukaku.org/181/

src = File.read(ARGV.shift)

hist = {}

src.each_byte do |c|
  c = c.chr
  if hist.member?(c)
    hist[c] += 1
  else
    hist[c] = 1
  end
end

hist.to_a.sort{|a,b| b[1] <=> a[1]}.each do |pair|
  puts "#{pair[0].inspect}: #{pair[1]}"
end


