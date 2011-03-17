#! ruby
#  encoding: utf-8

require 'pathname'
require 'find'
require 'optparse'


SCRIPT_VERSION = "0.0.1"


def kurai(n)
  s = []
  n.to_s.reverse.split("").each_with_index do |c, i|
    if i % 3 == 0 && i != 0
      s << ","
    end
    s << c
  end
  s.join("").reverse
end


options = {}
opts = OptionParser.new
opts.banner =<<EOB
#{opts.program_name} - Report file size.
Usage: #{opts.program_name} [option] DIR
EOB
opts.on('--aggregate-ext', 'Aggregate each ext.'){|v| options[:aggregate_ext] = true}
opts.on_tail('-h', '--help', 'show this message'){|v| puts opts; exit}
opts.on_tail('-v', '--version', 'show version'){|v| puts SCRIPT_VERSION; exit}
opts.parse!


files = []
Find.find(ARGV.shift) do |f|
  f = Pathname.new(f)
  if f.file?
    files << {:size => f.size, :path => f.expand_path}
  end
end


if options[:aggregate_ext]
  filetypes = {}
  files.each do |f|
    ext = f[:path].extname.downcase
    filetypes[ext] = 0 if filetypes[ext].nil? 
    filetypes[ext] += f[:size]
  end
  filetypes.to_a.sort{|a1,a2| a2[1] <=> a1[1]}.each do |a|
    printf("%20s     %-10s\n", kurai(a[1]), a[0])
  end
else
  files.each do |f|
    printf("%-15d%-250s\n", f[:size], f[:path])
  end
end

