#! ruby
# -*- encoding: utf-8 -*-

require 'optparse'


SCRIPT_VERSION = "0.1"

class Counter
  def initialize
    @data = {}
  end

  def up(val)
    if @data[val]
      @data[val] += 1
    else
      @data[val] = 1
    end
  end

  def histogram
    @data.keys.sort.each do |v|
      n = @data[v]
      puts "#{v}: (#{n.to_s.rjust(3)}) " + "*" * n
    end
  end
end


psr = OptionParser.new
psr.banner =<<EOB
Usage: #{psr.program_name} FILE
EOB
psr.on_tail('-v', '--version', %q[show version.]){puts "#{psr.program_name} v#{SCRIPT_VERSION}"; exit}
psr.on_tail('-h', '--help', %q[show this message.]){puts "#{psr}"; exit}
begin
  psr.parse!
rescue OptionParser::InvalidOption => err
  err_exit(err.message)
end


data = File.readlines(ARGV.shift).map{|l| l.chomp}
counter = Counter.new
data.each{|d| counter.up(d)}
counter.histogram

