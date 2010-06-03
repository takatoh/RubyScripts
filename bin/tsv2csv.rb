#!ruby
# -*- encoding: cp932 -*-
#
#  Convert TSV to CSV.
#

require 'csv'
require 'optparse'

@options = {}
opt = OptionParser.new
opt.on('-o', '--out=FILE', 'Output to FILE.'){|v| @options[:outfile] = v}
opt.parse!

tsvfile = ARGV.shift
csvfile = @options[:outfile] || tsvfile.sub(/\.tsv\Z/, ".csv")

s = CSV.generate("") do |writer|
  File.readlines(tsvfile).each do |r|
    writer << (r.chomp.split("\t"))
  end
end
File.open(csvfile, "w"){|f| f.write(s)}

