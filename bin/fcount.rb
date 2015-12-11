#!/usr/bin/env ruby
# coding: utf-8
#
# fc.rb - File counter
#

require 'pathname'
require 'optparse'


SCRIPT_VERSION = "0.0.1"

class FileCounter

  attr_reader :dir

  def initialize(dir, opts = {})
    @dir = Pathname.new(dir)
    @options = opts
  end

  def count
    counts = []
    if @options[:recursive] or @options[:summarize]
      @dir.children.select{|c| c.directory? }.each do |d|
        counts.concat(FileCounter.new(d, @options).count)
      end
    end
    files = @dir.children.select{|c| c.file? }
    if @options[:type]
      files = files.select{|f| f.extname.downcase == @options[:type] }
    end
    counts << {path: @dir.to_s, count: files.size}
    if @options[:summarize]
      dir = @dir.to_s
      count = counts.map{|c| c[:count] }.inject(:+)
      [{path: dir, count: count}]
    else
      counts
    end
  end

end   # of class FileCounter


options = {}
parser = OptionParser.new
parser.banner = <<EOB
#{parser.program_name} - File counter
Usage: #{parser.program_name} [options] <dir>

EOB
parser.on("-r", "--recursive", "Rcursive mode."){|v| options[:recursive] = true }
parser.on("-s", "--summarize", "Display only a total for each directory."){|v|
  options[:summarize] = true
}
parser.on("-t", "--type=TYPE", "Specify file extname."){|v| options[:type] = v }
parser.on_tail("-v", "--version", "Show version."){|v| puts "v#{SCRIPT_VERSION}"; exit }
parser.on_tail("-h", "--help", "Show this message."){|v| print parser; exit }
parser.parse!


fc = FileCounter.new(ARGV.shift, options)
counts = fc.count
counts.each do |c|
  printf("%5d  %s\n", c[:count], c[:path])
end
