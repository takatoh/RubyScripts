#! ruby
# -*- encoding: utf-8 -*-
#
# Print HTTP header.
#
# Rubygem `HTTPClient' is required.
# You can install the gem:
#
# <tt>gem install httpclient</tt>
#

SCRIPT_VERSION = "v0.1.1"

require 'httpclient'
require 'optparse'


options = {}
opts = OptionParser.new
opts.banner =<<EOB
Usage: #{opts.program_name} [options] <url>
EOB
opts.on('-s', '--status', 'Show status instead headers.'){ options[:status] = true }
opts.on_tail('-h', '--help', 'Show thismessage.'){ print opts; exit }
opts.on_tail('-v', '--version', 'Show version.'){ puts SCRIPT_VERSION; exit }
opts.parse!


url = ARGV.shift

clnt = HTTPClient.new
if options[:status]
  puts clnt.head(url).status
else
  clnt.head(url).header.all.each do |name, value|
    puts "#{name}: #{value}"
  end
end
