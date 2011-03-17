#! ruby
#  encoding: utf-8

require 'pathname'
require 'find'

Find.find(ARGV.shift) do |f|
  f = Pathname.new(f)
  if f.file?
    printf("%-15d%-250s\n", f.size, f.expand_path)
  end
end


