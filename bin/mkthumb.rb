#!ruby
# -*- encoding: utf-8 -*-

require 'optparse'


SCRIPT_VERSION = "v.0.1.1"


options = {:geometry => "320x320"}
opts = OptionParser.new
opts.banner =<<EOB
Usage: #{opts.program_name} [options] <orig> <thumbnail>
EOB
opts.on('-g', '--geometry=STRING', String, 'geometry of thumbnail(default is "320x320")') do
  |v| options[:geometry] = v
end
opts.on_tail('-h', '--help', 'show this message'){|v| print opts; exit}
opts.on_tail('-v', '--version', 'show version'){ puts SCRIPT_VERSION; exit }
opts.parse!

unless ARGV.size == 2
  puts opts
  exit
end

orig_file, thumb_file = ARGV
system("convert -scale #{options[:geometry]} #{orig_file} #{thumb_file}")
