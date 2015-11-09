#!/usr/bin/env ruby
# encoding: utf-8
#
#  Scoop files from sub directories.
#

require 'pathname'
require 'fileutils'
require 'optparse'


SCRIPT_VERSION = "v0.1.2"

options = {}
opts = OptionParser.new
opts.banner =<<EOB
#{opts.program_name} - Scoop files from sub directories.
Usage: #{opts.program_name} [option] DIR [DEST]
EOB
opts.on_tail('-r', '--remove', 'remove files in sub directories'){|v| options[:remove] = true}
opts.on_tail('-h', '--help', 'show this message'){|v| puts opts; exit}
opts.on_tail('-v', '--version', 'show version'){|v| puts SCRIPT_VERSION; exit}
opts.parse!


src = Pathname.new(ARGV.shift)
dest = Pathname.new(ARGV.shift || ".")

counter = 0
src.find do |f|
  if f.file?
    puts f
    counter += 1
    if options[:remove]
      FileUtils.mv(f, dest + f.basename)
    else
      FileUtils.cp(f, dest + f.basename)
    end
  end
end

puts ""
puts "#{counter.to_s} files diped."
