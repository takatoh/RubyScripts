#! ruby
# encoding: utf-8
#
#  Dip files from sub-directories.
#

require 'find'
require 'fileutils'
require 'pathname'
require 'optparse'


SCRIPT_VERSION = "v0.1.0"

options = {}
opts = OptionParser.new
opts.banner =<<EOB
#{opts.program_name} - Dip files from sub directories.
Usage: #{opts.program_name} [option] DIR [DEST]
EOB
opts.on_tail('-h', '--help', 'show this message'){|v| puts opts; exit}
opts.on_tail('-v', '--version', 'show version'){|v| puts SCRIPT_VERSION; exit}
opts.parse!


src = Pathname.new(ARGV.shift)
dest = ARGV.shift
if dest
  dest = Pathname.new(dest)
else
  dest = Pathname.new(".")
end

counter = 0
Find.find(src) do |f|
  file = Pathname.new(f)
  if file.file?
    puts f
    counter += 1
    FileUtils.cp(f, dest + file.basename)
  end
end

puts ""
puts "#{counter.to_s} files diped."

