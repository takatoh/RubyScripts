# encoding: utf-8

require 'find'
require 'optparse'


SCRIPT_VERSION = "v0.1.0"

@options = { :method => :file? }
opts = OptionParser.new
opts.banner =<<EOB
Find file (or directory) in directory.
Usega: #{opts.program_name} [options] NANME DIR
EOB
opts.on('-d', '--directory', 'Find the directory instead of file.'){|v|
  @options[:method] = :directory?
}
opts.on_tail('-v', '--version', 'Show version.'){|v|
  print SCRIPT_VERSION
  exit
}
opts.on_tail('-h', '--help', 'Show this message.'){|v|
  print opts
  exit
}
opts.parse!


name = ARGV.shift.downcase
basedir = ARGV.shift

Find.find(basedir) do |f|
  if File.send(@options[:method], f)
    if File.basename(f).downcase == name
      puts f
    end
  end
end

