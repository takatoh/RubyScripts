#!ruby
# -*- encoding: utf-8 -*-

require 'rubygems'
require 'optparse'


options = {:geometry => "320x320"}
opts = OptionParser.new
opts.banner =<<EOB
Usage: #{File.basename($0)} [options] orig thumbnail
EOB
opts.on('-g', '--geometry=STRING', String, 'geometry of thumbnail(default is "320x320")'){
  |v| options[:geometry] = v}
opts.parse!

unless ARGV.size == 2
  puts opts
  exit
end

orig_file, thumb_file = ARGV
system("convert -scale #{options[:geometry]} #{orig_file} #{thumb_file}")

