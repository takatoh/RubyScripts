#!/usr/bin/env ruby
# coding: utf-8
#
# fcount.rb - File counter
#

require 'pathname'
require 'optparse'


SCRIPT_VERSION = "0.2.0"

class FileCounter

  attr_reader :dir

  def initialize(dir, opts = {})
    @dir = Pathname.new(dir)
    @options = opts
  end

  def count
    counts = []
    if @options[:just] > 1
      @dir.children.select{|c| c.directory? }.each do |d|
        j = @options[:just]
        counts.concat(FileCounter.new(d, @options.merge({:just => j - 1})).count)
      end
    elsif @options[:just] == 1
      if @options[:recursive]
        @dir.children.select{|c| c.directory? }.each do |d|
          counts.concat(FileCounter.new(d, @options).count)
        end
      end
      if @options[:dir]
        dirs = @dir.children.select{|c| c.directory? }
        counts << {path: @dir.to_s, count: dirs.size}
      else
        files = @dir.children.select{|c| c.file? }
        if @options[:type]
          files = files.select{|f| f.extname.downcase == @options[:type] }
        end
        counts << {path: @dir.to_s, count: files.size}
      end
    end
    if @options[:summarize]
      dir = @dir.to_s
      count = counts.map{|c| c[:count] }.inject(:+)
      [{path: dir, count: count}]
    else
      counts
    end
  end

end   # of class FileCounter


options = {
  :just => 1
}
parser = OptionParser.new
parser.banner = <<EOB
#{parser.program_name} - File counter
Usage: #{parser.program_name} [options] <dir>

EOB
parser.on("-r", "--recursive", "Rcursive mode."){|v| options[:recursive] = true }
parser.on("-s", "--summarize", "Display only a total."){|v| options[:summarize] = true }
parser.on("-t", "--type=TYPE", "Specify file extname."){|v| options[:type] = v }
parser.on("-d", "--directory", "Count directory instead of file."){|v| options[:dir] = true }
parser.on("-j", "--just-depth=N", "Count if depth is just N."){|v| options[:just] = v.to_i }
parser.on_tail("-v", "--version", "Show version."){|v| puts "v#{SCRIPT_VERSION}"; exit }
parser.on_tail("-h", "--help", "Show this message."){|v| print parser; exit }
parser.parse!


fc = FileCounter.new(ARGV.shift, options)
counts = fc.count
counts.each do |c|
  printf("%5d  %s\n", c[:count], c[:path])
end
