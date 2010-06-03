#!ruby
# -*- encoding: utf-8 -*-
#
#  Convert CSV to TSV.
#

require 'csv'
require 'optparse'

@options = {}
opt = OptionParser.new
opt.on('-o', '--out=FILE', 'Output to FILE.'){|v| @options[:outfile] = v}
opt.parse!

csvfile = ARGV.shift
tsvfile = @options[:outfile] || csvfile.sub(/\.csv\Z/, ".tsv")

open(tsvfile, 'w') do |tsv|
  CSV.foreach(csvfile) do |r|
    tsv.puts r.join("\t")
  end
end

