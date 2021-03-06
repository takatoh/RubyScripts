#!ruby
# encoding: utf-8
#
#  justhere.rb -- Make command to come back to here!
#

require 'optparse'

psr = OptionParser.new
psr.banner = <<-EOM
#{psr.program_name} - Make command to come back to here!

Usage: justhere [name-of-command]
EOM
psr.parse!

home = ENV['HOME'] || ENV['HOMEDRIVE'] + ENV['HOMEPATH']
here = Dir.pwd.gsub("/", "\\")
filename = ARGV.shift || File.basename(here)

File.open("#{home}/#{filename}.cmd", "w") do |f|
  f.print "@cd #{here}\n"
end

