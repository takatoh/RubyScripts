#!ruby
# encoding: utf-8

require 'optparse'


def surfix(name)
  /\.rb\z/i.match(name) ? name : name + ".rb"
end


target = ENV['PATH'].split(";")

psr = OptionParser.new
psr.on('-l', '--library', 'search library.'){ target = $LOAD_PATH }
psr.parse!

if ARGV.empty?
  print psr
  exit
else
  filename = surfix(ARGV.shift)
end

script = nil
target.each do |dir|
  s = "#{dir}/#{filename}"
  if File.exist?(s)
    script = s
    break
  end
end

if script
  puts script.gsub("\\", "/")
else
  puts "Scritp not found  -  #{filename}"
end

