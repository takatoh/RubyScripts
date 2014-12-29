wpfile = ARGV.shift

File.open(wpfile, "r") do |f|
  f.each do |line|
    if /- files/ =~ line
      file = line.chomp.sub(/\A- /, "")
      unless File.exist?(file)
        puts file
      end
    end
  end
end
